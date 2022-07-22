//
//  SVProgressHUD.swift
//  NCBApp
//
//  Created by Thuan on 8/21/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import UIKit

fileprivate let progressTag = 27102018

class SVProgressHUD {
    class func getWindown() -> UIWindow? {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return nil }
        return window
    }
    
    class func show() {
        SVProgressHUD.dismiss()
        
        guard let windown = getWindown() else {
            return
        }
        
        let wrapperView = UIView()
        wrapperView.isUserInteractionEnabled = true
        wrapperView.frame = CGRect(x: 0, y: 0, width: windown.frame.width, height: windown.frame.height)
        wrapperView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        wrapperView.tag = progressTag
        windown.addSubview(wrapperView)
        
        let containerView = UIView()
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15
        containerView.backgroundColor = UIColor.clear
        wrapperView.addSubview(containerView)
        
        ConstraintUtil.height(item: containerView, constant: 100)
        ConstraintUtil.width(item: containerView, constant: 100)
        
//        containerView.addShadow(offset: CGSize(width: 0, height: 0), color: UIColor.black, opacity: 0.35, radius: 10)
        
//        let lbTitle = UILabel()
//        lbTitle.text = "Vui lòng chờ trong giây lát"
//        lbTitle.font = regularFont(size: 14)
//        lbTitle.textColor = ColorName.blackText.color
//        containerView.addSubview(lbTitle)
//
//        lbTitle.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(25)
//        }
        
        var isHiddenAnimationView: Bool = true
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_loading.png")
        containerView.addSubview(imageView)
        ConstraintUtil.height(item: imageView, constant: 60)
        ConstraintUtil.center(item: imageView, toItem: containerView)
        
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                isHiddenAnimationView = !isHiddenAnimationView
                imageView.animate(isHidden: isHiddenAnimationView, duration: 1.0)
            }
        } else {
            // Fallback on earlier versions
        }
        
        imageView.animate(isHidden: isHiddenAnimationView, duration: 1.0)
        
//        let animationView = AnimationView()
//        let animation = Animation.named("lottie_trail_loading")
//
//        animationView.animation = animation
//        animationView.contentMode = .scaleAspectFit
//        animationView.play(fromProgress: 0,
//                           toProgress: 1,
//                           loopMode: LottieLoopMode.repeat(1.0),
//                           completion: { (finished) in
//                            if finished {
//                                print("Animation Complete")
//                            } else {
//                                print("Animation cancelled")
//                            }
//        })
//        containerView.addSubview(animationView)
        
//        animationView.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
////            make.top.equalTo(lbTitle.snp.bottom).offset(-10)
//            make.width.height.equalTo(100)
//        }
    }
    
    class func dismiss() {
        guard let windown = getWindown() else {
            return
        }
        
        for view in windown.subviews {
            if view.tag == progressTag {
                view.removeFromSuperview()
                break
            }
        }
    }
    
    class func update() {
    // your repeating function
    }
    
}

extension UIView {
    // MARK: - Config
    /// The default duration for fading-animations, measured in seconds.
    public static let defaultFadingAnimationDuration: TimeInterval = 1.0

    // MARK: - Public methods
    /// Updates the view visiblity.
    ///
    /// - Parameters:
    ///   - isHidden: The new view visibility.
    ///   - duration: The duration of the animation, measured in seconds.
    ///   - completion: Closure to be executed when the animation sequence ends. This block has no return value and takes a single Boolean
    ///                 argument that indicates whether or not the animations actually finished before the completion handler was called.
    ///
    /// - SeeAlso: https://developer.apple.com/documentation/uikit/uiview/1622515-animatewithduration
    public func animate(isHidden: Bool, duration: TimeInterval = UIView.defaultFadingAnimationDuration, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            fadeOut(duration: duration,
                    completion: completion)
        } else {
            fadeIn(duration: duration,
                   completion: completion)
        }
    }

    /// Fade out the current view by animating the `alpha` to zero and update the `isHidden` flag accordingly.
    ///
    /// - Parameters:
    ///   - duration: The duration of the animation, measured in seconds.
    ///   - completion: Closure to be executed when the animation sequence ends. This block has no return value and takes a single Boolean
    ///                 argument that indicates whether or not the animations actually finished before the completion handler was called.
    ///
    /// - SeeAlso: https://developer.apple.com/documentation/uikit/uiview/1622515-animatewithduration
    public func fadeOut(duration: TimeInterval = UIView.defaultFadingAnimationDuration, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       animations: {
                           self.alpha = 0.5
                       },
                       completion: { isFinished in
                           // Update `isHidden` flag accordingly:
                           //  - set to `true` in case animation was completely finished.
                           //  - set to `false` in case animation was interrupted, e.g. due to starting of another animation.
                           self.isHidden = isFinished

                           completion?(isFinished)
        })
    }

    /// Fade in the current view by setting the `isHidden` flag to `false` and animating the `alpha` to one.
    ///
    /// - Parameters:
    ///   - duration: The duration of the animation, measured in seconds.
    ///   - completion: Closure to be executed when the animation sequence ends. This block has no return value and takes a single Boolean
    ///                 argument that indicates whether or not the animations actually finished before the completion handler was called.
    ///
    /// - SeeAlso: https://developer.apple.com/documentation/uikit/uiview/1622515-animatewithduration
    public func fadeIn(duration: TimeInterval = UIView.defaultFadingAnimationDuration, completion: ((Bool) -> Void)? = nil) {
//        if isHidden {
//            // Make sure our animation is visible.
//            isHidden = false
//        }

        UIView.animate(withDuration: duration,
                       animations: {
                           self.alpha = 1.0
                       },
                       completion: completion)
    }
}
