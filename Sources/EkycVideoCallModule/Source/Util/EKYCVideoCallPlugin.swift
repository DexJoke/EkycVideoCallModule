//
//  EKYCPlugin.swift
//  EKYCFramework
//
//  Created by Nguyen Dat on 17/08/2021.
//

import UIKit

public protocol EKYCVideoCallPluginDelegate: AnyObject {
   
}

public class EKYCVideoCallPlugin {
    public static let share = EKYCVideoCallPlugin()
    weak var delegate: EKYCVideoCallPluginDelegate?
    private weak var viewcontroller: UIViewController?
 
    private init() {}
    
    public func openViewController(with viewController: UIViewController, delegate: EKYCVideoCallPluginDelegate, language: LocalizeLanguage) {
        LocalizeManager.shared.setCurrentBundlePath(language)
        self.delegate = delegate
        self.viewcontroller = viewController
        reqeustLogin()
    }
    
    private func pushToCallVC(sessionId: String) {
        let vc = VideoCallVC(sessionId: sessionId)
        vc.modalPresentationStyle = .fullScreen
        
        viewcontroller?.present(vc, animated: true)
    }
    
    private func reqeustLogin() {
        SessionManager.share.getSesstionId { [weak self] loginRespone in
            self?.pushToCallVC(sessionId: loginRespone.sessionid)
        } onError: { error in
            guard let vc = self.viewcontroller else {
                return
            }

            SVProgressHUD.dismiss()
            self.showProblemDialog(caller: vc)
        }
    }
    
    private func handleError(_ errorCode: Int?, _ errorMessage: String? ) {
        guard let vc = self.viewcontroller else {
            return
        }

        SVProgressHUD.dismiss()
        self.showProblemDialog(caller: vc)
    }
    
    private func showProblemDialog(caller: UIViewController) {
        let alert = UIAlertController(title: "txt_alert".localized(), message: "txt_ekyc_problem".localized(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "txt_close".localized(), style: UIAlertAction.Style.default, handler: nil))
        viewcontroller?.present(alert, animated: true)
    }
    
    private func showDialogConnectError(caller: UIViewController) {
        let alert = UIAlertController(title: "txt_alert".localized(), message: "txt_dis_connected".localized(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "txt_close".localized(), style: UIAlertAction.Style.default, handler: nil))
        viewcontroller?.present(alert, animated: true)
    }
}
