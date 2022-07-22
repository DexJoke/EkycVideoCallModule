//
//  VideoCallVC.swift
//  VideoCallDemo
//
//  Created by Tùng Anh Nguyễn on 23/02/2022.
//

import FCSDKiOS
import UIKit
import AVFoundation

class VideoCallVC: UIViewController {
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var loadingCallView: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnChangeSpeaker: UIButton!
    @IBOutlet weak var btnEndCall: UIButton!
    
    private var sessionId: String!
    private var acbuc: ACBUC!
    private var acbClientCall: ACBClientCall!
    private var permissionManager: PermissionManager!
    private var isEndCall = false
    private var isSpeakerOn = true
    var audioDeviceManager: ACBAudioDeviceManager?
    //Timer
    private var counter = 0
    private weak var timer: Timer?
    private var interval = 1.0
    
    init(sessionId: String) {
        super.init(nibName: "VideoCallVC", bundle: Bundle.module)
        self.sessionId = sessionId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        permissionManager = PermissionManager()
        localView.isHidden = true
        loadingCallView.isHidden = false
        lblTime.isHidden = true
        changeControlButton(isEnable: false)
        checkCameraPermission()
    }
    
    @IBAction func onEndCall(_ sender: Any) {
        endCall()
    }
    
    
    @IBAction func onChangeSpeaker(_ sender: Any) {
        isSpeakerOn.toggle()
        updateSpeakerButton()
        setAudioOutputSpeaker(enabled: isSpeakerOn)
    }
}
 
extension VideoCallVC {
    private func changeControlButton(isEnable: Bool) {
        btnEndCall.isEnabled = isEnable
        btnChangeSpeaker.isEnabled = isEnable
    }
    
    private func createSession() {
        self.acbuc = ACBUC.uc(withConfiguration: self.sessionId, delegate: self) as! ACBUC
        self.acbuc.acceptAnyCertificate(true)
        self.acbuc.useCookies = true
        self.acbuc.setNetworkReachable(true)
        self.acbuc.startSession()
    }
    
    private func updateSpeakerButton() {
        let imageName = isSpeakerOn ? "icon_speaker_on" : "icon_speaker_off"
        let image = UIImage(named: imageName, in: Bundle.module, with: nil)
        btnChangeSpeaker.setImage(image, for: .normal)
    }
    
    private func endCall() {
        acbuc.delegate = nil
        acbuc?.stopSession()
        acbClientCall?.end()
        logout()
        self.dismiss(animated: true)
    }
    
    private func createCall() {
        guard let outboundCall = self.acbuc.phone.createCall(
            toAddress: AppConsts.agent,
            withAudio: .sendAndReceive,
            video: .sendAndReceive,
            delegate: self
        ) else {
            print("-----------------------")
            print("create call failed")
            print("-----------------------")
            return
        }
        
        outboundCall.enableLocalVideo(true)
        outboundCall.remoteView = remoteView
        self.acbuc.phone.previewView = localView
        self.acbuc.phone.preferredCaptureResolution = ACBVideoCapture.resolution1280x720
        self.acbuc.phone.preferredCaptureFrameRate = 30
        audioDeviceManager = acbuc.phone.audioDeviceManager
        acbClientCall = outboundCall
    }
    
    private func logout() {
        SessionManager.share.logout(sessionId: sessionId)
    }
    
    private func onCameraPermissionDenied() {
        
    }
    
    private func onMicrioPhonePermissionDenied() {
        
    }
    
    func showMessage(message: String, completion: (() -> Void)? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "txt_alert".localized(), message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "txt_close".localized(), style: UIAlertAction.Style.default, handler: { action in
                completion?()
            }))
            
            self?.present(alert, animated: true)
        }
    }
}

extension VideoCallVC {
    private func setAudioOutputSpeaker(enabled: Bool) {
        audioDeviceManager?.setAudioDevice(enabled ? .speakerphone : .wiredHeadset)
    }
}

extension VideoCallVC {
    func createTimer() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.timer != nil {
                self.stopTimer()
            }
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                self?.timerAction()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func timerAction() {
        counter += 1
        updateTimerLabel()
    }
    
    private func updateTimerLabel() {
        let minute: Int = counter / 60
        let second: Int = counter % 60
        lblTime.text = String(format: "%02d:%02d", minute, second)
    }
}


extension VideoCallVC {
    private func checkMicorPremission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            createSession()
        case .denied:
            showDialogGotoAppPrivacySettings(message: "txt_setting_microphone_permissions".localized())
        case .undetermined:
            reqeustMicrophoenPermission()
        @unknown default:
            onMicrioPhonePermissionDenied()
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            requestCameraPermission()
        case .denied:
            showDialogGotoAppPrivacySettings(message: "txt_setting_camera_permissions".localized())
        case .authorized:
            checkMicorPremission()
        default:
            onCameraPermissionDenied()
        }
    }
    
    func showDialogGotoAppPrivacySettings(message: String) {
        let alert = UIAlertController(title: "txt_alert".localized(),
                                      message: message,
                                      preferredStyle: .alert)
        
        let notNowAction = UIAlertAction(title: "txt_resfuse".localized(),
                                         style: .cancel,
                                         handler: nil)
        alert.addAction(notNowAction)
        
        let openSettingsAction = UIAlertAction(title: "txt_go_to_setting".localized(),
                                               style: .default) { [unowned self] (_) in
            permissionManager.gotoAppPrivacySettings()
        }
        alert.addAction(openSettingsAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func reqeustMicrophoenPermission() {
        permissionManager.requestRecordPremission { [weak self] in
            self?.createSession()
        } onAccessDenied: { [weak self] in
            self?.showDialogGotoAppPrivacySettings(message: "txt_setting_camera_permissions".localized())
        }
    }
    
    private func requestCameraPermission() {
        permissionManager.requestCameraPermission(onAccessGranted: onAccessGranted, onAccessDenied: { [weak self] in
            self?.showDialogGotoAppPrivacySettings(message: "txt_setting_camera_permissions".localized())
        })
    }
    
    func onAccessGranted() {
        checkMicorPremission()
    }
}

extension VideoCallVC: ACBUCDelegate {
    func ucDidStartSession(_ uc: ACBUC) {
        DispatchQueue.main.async { [weak self] in
            self?.localView.isHidden = false
        }
        createCall()
    }
    
    func ucDidFail(toStartSession uc: ACBUC) {
        print("ucDidFail")
    }
    
    func ucDidReceiveSystemFailure(_ uc: ACBUC) {
        print("ucDidReceiveSystemFailure")
        
    }
    
    func ucDidLoseConnection(_ uc: ACBUC) {
        print("ucDidLoseConnection")
    }
    
    
}

extension VideoCallVC: ACBClientCallDelegate {
    func callDidReceiveMediaChangeRequest(_ call: ACBClientCall) {
        print("callDidReceiveMediaChangeRequest(_ call: ACBClientCall)")

    }
    
    func call(_ call: ACBClientCall, didChange status: ACBClientCallStatus) {
        print("call(_ call: ACBClientCall, didChange status: \(status)")
        if status != .inCall {
            DispatchQueue.main.async { [weak self] in
                self?.loadingCallView.isHidden = status != .inCall
            }
        }

        switch status {
        case .setup:
            print("status---setup")
        case .alerting:
            print("status---alerting")
        case .ringing:
            print("status---ringing")
        case .mediaPending:
            break
        case .inCall:
            print("status---inCall")
            audioDeviceManager?.setAudioDevice(.speakerphone)
            audioDeviceManager?.start()
            DispatchQueue.main.async { [weak self] in
                self?.lblTime.isHidden = false
                self?.createTimer()
                self?.changeControlButton(isEnable: true)
            }
        case .timedOut:
            print("status---timedOut")
            endCall()
//            showMessage(message: "Call timed out", completion: endCall)
        case .busy:
            print("status---busy")
            endCall()
//            showMessage(message: "User is Busy", completion: endCall)
        case .notFound:
            print("status---notFound")
            endCall()
//            showMessage(message: "Could not find user", completion: endCall)
        case .error:
            print("status---error")
            endCall()
//            showMessage(message: "Unkown Error", completion: endCall)
        case .ended:
            print("status---ended")
            endCall()
//            showMessage(message: "Call will End", completion: endCall)
        @unknown default:
            print("status---@unknown default")
            endCall()
            break
        }
    }
    
    func call(_ call: ACBClientCall, didReceiveCallFailureWithError error: Error) {
        print("call(_ call: ACBClientCall, didReceiveCallFailureWithError error: Error)")

    }
    
    
}
