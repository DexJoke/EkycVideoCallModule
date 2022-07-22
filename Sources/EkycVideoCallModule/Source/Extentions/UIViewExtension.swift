//
//  UIViewExtension.swift
//  ncb-ekyc
//
//  Created by datnx on 11/08/2021.
//

import UIKit

enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    func drawGradient (startColor: UIColor, endColor: UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        
        let cyan: UIColor = endColor
        
        let green: UIColor = startColor
        
        gradient.colors = [cyan.cgColor, green.cgColor]
        
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        // gradient.locations = [0.0 , 1.0]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 40.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 40.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    // animation
    func expandAnimation(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.5
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: completion)
    }
    
    func shrinkAnimation(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: completion)
    }
    
    func removeSubView() {
        for subview in self.subviews {
            subview.removeFromSuperview() }
    }
    
    func scaleAnimation(duration: TimeInterval, delay: TimeInterval = 0, scale: [Double]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            bounceAnimation.values = scale
            bounceAnimation.duration = TimeInterval(duration)
            bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
            self.layer.add(bounceAnimation, forKey: nil)
        }
    }
    
    func removeFromStackView() {
        guard let stackView = self.superview as? UIStackView  else { return }
        stackView.removeArrangedSubview(self)
        self.removeFromSuperview()
    }
    
    func hasSubview(viewType: UIView.Type) -> Bool {
        if type(of: self) == viewType { return true }
        for subview in self.subviews {
            if subview.hasSubview(viewType: viewType) { return true }
        }
        return false
    }
    
    var width : CGFloat {
        get { return self.frame.size.width }
        set { self.frame.size.width = newValue }
    }
    
    var height : CGFloat {
        get { return self.frame.size.height }
        set { self.frame.size.height = newValue }
    }
    
    var aspectRatio : CGFloat { return self.width == 0 ? 0 : self.height / self.width }
    
    var size : CGSize {
        get { return self.frame.size }
        set { self.frame.size = newValue }
    }
    
    var left : CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    
    var right : CGFloat {
        get { return self.frame.origin.x + self.width }
        set { self.frame.origin.x = newValue - self.width }
    }
    
    var top : CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    
    var bottom : CGFloat {
        get { return self.frame.origin.y + self.height }
        set { self.frame.origin.y = newValue - self.height }
    }
    
    var centerX : CGFloat {
        get { return self.frame.origin.x + self.width / 2 }
        set { self.frame.origin.x = newValue - self.width / 2 }
    }
    
    var centerY : CGFloat {
        get { return self.frame.origin.y + self.height / 2 }
        set { self.frame.origin.y = newValue - self.height / 2 }
    }
    
    var topLeft : CGPoint {
        get { return CGPoint(x: self.left, y: self.top) }
        set { self.left = newValue.x
            self.top = newValue.y }
    }
    
    var topCenter : CGPoint {
        get { return CGPoint(x: self.centerX, y: self.top) }
        set {
            self.centerX = newValue.x
            self.top = newValue.y
        }
    }
    
    var topRight : CGPoint {
        get { return CGPoint(x: self.right, y: self.top) }
        set {
            self.right = newValue.x
            self.top = newValue.y
        }
    }
    
    var centerLeft : CGPoint {
        get { return CGPoint(x: self.left, y: self.centerY) }
        set {
            self.left = newValue.x
            self.centerY = newValue.y
        }
    }
    
    var centerRight : CGPoint {
        get { return CGPoint(x: self.right, y: self.centerY) }
        set {
            self.right = newValue.x
            self.centerY = newValue.y
        }
    }
    
    var bottomLeft : CGPoint {
        get { return CGPoint(x: self.left, y: self.bottom) }
        set {
            self.left = newValue.x
            self.bottom = newValue.y
        }
    }
    
    var bottomCenter : CGPoint {
        get { return CGPoint(x: self.centerX, y: self.bottom) }
        set {
            self.centerX = newValue.x
            self.bottom = newValue.y
        }
    }
    
    var bottomRight : CGPoint {
        get { return CGPoint(x: self.right, y: self.bottom) }
        set {
            self.right = newValue.x
            self.bottom = newValue.y
        }
    }
    
    var halfWidth : CGFloat { return self.width / 2 }
    var halfHeight : CGFloat { return self.height / 2 }
    var halfPoint : CGPoint { return CGPoint(x: self.halfWidth, y: self.halfHeight) }
    var halfSize : CGSize { return CGSize(width: self.halfWidth, height: self.halfHeight) }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return layer.shadowColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.shadowColor = newValue?.cgColor
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowAlpha: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
}
