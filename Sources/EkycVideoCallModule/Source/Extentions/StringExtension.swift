//
//  StringExtension.swift
//  ncb-ekyc
//
//  Created by datnx on 11/08/2021.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: LocalizeManager.shared.tableName,
                                 bundle: LocalizeManager.shared.bundle,
                                 comment: "")
    }
    
    func localized(arg: Any...) -> String {
        return String.init(format: self.localized(), arg)
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(to: Int) -> String {
        if(to > self.count)
        {
            return "";
        }
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func isNumber() -> Bool {
        let num = Int(self)
        return num != nil
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        let range = startIndex..<endIndex
        return String(self[range])
    }
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    static func hasValue(string: String?) -> Bool {
        return string != nil && !string!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
    }
    
    func isEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isNumberPhone() -> Bool {
        let phoneRegex = "([0]+(3|5|7|8|9|1[2|6|8|9]))+([0-9]{8})"
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return phonePred.evaluate(with: self)
    }
    
    func forSorting() -> String {
        let simple = folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
        let nonAlphaNumeric = CharacterSet.alphanumerics.inverted
        return simple.components(separatedBy: nonAlphaNumeric).joined(separator: "")
    }
    
    func toDate() -> Date? {
        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let yourDate = dateFor.date(from: self)
        return yourDate
    }
    
    func regMatch(pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return false
        }
        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        return matches.count > 0
    }
    
    func regReplace(pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: with)
    }
    
    func regMatchToRange(pattern: String, options: NSRegularExpression.Options = []) -> [NSRange] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return [NSRange]()
        }
        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        var range = [NSRange]()
        for i in 0..<matches.count {
            for j in 0 ..< matches[i].numberOfRanges {
                range.append(matches[i].range(at: j))
            }
        }
        return range
    }

}
