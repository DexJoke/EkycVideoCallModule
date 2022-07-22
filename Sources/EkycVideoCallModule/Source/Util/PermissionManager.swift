//
//  PremisionManager.swift
//  ncb-ekyc
//
//  Created by macbook on 12/08/2021.
//

import Foundation
import AVFoundation
import UIKit

typealias Event = (() -> Void)

class PermissionManager {
    func requestRecordPremission(onAccessGranted: @escaping Event, onAccessDenied: @escaping Event) {
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            if granted {
                onAccessGranted()
            } else {
                onAccessDenied()
            }
        }
    }
    
    func requestCameraPermission(onAccessGranted: @escaping Event, onAccessDenied: @escaping Event) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response  in
            guard let _ = self else {
                return
            }
             response ? onAccessGranted() : onAccessDenied()
        }
    }
    
    func gotoAppPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
                assertionFailure("Not able to open App privacy settings")
                return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
