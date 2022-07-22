//
//  UIFontExtension.swift
//  EKYCFramework
//
//  Created by Nguyen Dat on 17/08/2021.
//

import Foundation
import UIKit

extension UIFont {
    
    private class MyDummyClass {}
    
    // load framework font in application
    public static let loadMyFonts: () = {
        loadFontWith(name: "SF-Pro-Display-Bold")
//        loadFontWith(name: "CREDC___", ofType: "ttf")
        loadFontWith(name: "SF-Pro-Text-Light")
        loadFontWith(name: "SF-Pro-Text-Regular")
        loadFontWith(name: "SF-Pro-Text-Bold")
        loadFontWith(name: "SF-Pro-Text-RegularItalic")
        loadFontWith(name: "SF-Pro-Text-Semibold")
        loadFontWith(name: "SF-Pro-Text-Medium")
        loadFontWith(name: "SF-Pro-Display-BoldItalic")
    }()
    //MARK: - Make custom font bundle register to framework
    static func loadFontWith(name: String, ofType: String = "otf") {
        let frameworkBundle = Bundle(for: MyDummyClass.self)
        let pathForResourceString = frameworkBundle.path(forResource: name, ofType: ofType)
        let fontData = NSData(contentsOfFile: pathForResourceString!)
        let dataProvider = CGDataProvider(data: fontData!)
        let fontRef = CGFont(dataProvider!)
        var errorRef: Unmanaged<CFError>? = nil
        
        if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
            NSLog("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
}
