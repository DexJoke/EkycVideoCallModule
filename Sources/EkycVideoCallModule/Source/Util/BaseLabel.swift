//
//  BaseLabel.swift
//  ncb-ekyc
//
//  Created by Tùng Anh Nguyễn on 04/10/2021.
//

import UIKit

class BaseLabel: UILabel {
    var attribute: [NSAttributedString.Key:Any]? //InterfaceBuilderでのattribute

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    func commonInit() {
        if self.text!.isEmpty { return }
        self.attribute = self.attributedText?.attributes(at: 0, effectiveRange: nil)
        self.updateAttribute()
    }
    
    func updateAttribute() {
        super.attributedText = NSAttributedString(string: self.text!.localized(), attributes: self.attribute)
    }
    
    override var text: String? {
        get { return super.text }
        set {
            if newValue == nil {
                super.text = nil
            } else if self.attribute == nil {
                super.text = newValue!.localized()
            } else {
                super.attributedText = NSAttributedString(string: newValue!.localized(), attributes: self.attribute)
            }
        }
    }
    
    override var textColor: UIColor! {
        get { return super.textColor }
        set {
            if self.attribute == nil {
                super.textColor = newValue
            } else {
                self.attribute![NSAttributedString.Key.foregroundColor] = newValue
                self.updateAttribute()
            }
        }
    }
    
    func exchangeByArg(arg: Any...) {
        self.text = LocalizeManager.shared.exchangeArg(str: self.text!, args: arg)
    }
}
