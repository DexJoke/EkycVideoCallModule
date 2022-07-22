//
//  LocalizeManager.swift
//  ncb-ekyc
//
//  Created by Tùng Anh Nguyễn on 04/10/2021.
//

import UIKit

public enum LocalizeLanguage: String {
    case vi = "vi"
    case en = "en"
}

class LocalizeManager {
    static let shared = LocalizeManager()
    private(set) var bundle: Bundle = Bundle.main
    let tableName: String = "ekyc_localizable"
    private init() {}
    
    func localize(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    func exchangeArg(str: String, args: [Any]) -> String {
        return String.init(format: str, args)
    }
    
    func getBundle() -> Bundle {
        return Bundle.module
    }
    
    func setCurrentBundlePath(_ language: LocalizeLanguage) {
        let ekycBundle = getBundle()
        guard let bundlePath = ekycBundle.path(forResource: language.rawValue,
                                            ofType: "lproj"),
            let langBundle = Bundle(path: bundlePath) else {
            bundle = Bundle.main
            return
        }
        bundle = langBundle
    }
}
