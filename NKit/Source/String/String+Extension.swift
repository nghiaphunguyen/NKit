//
//  String+Extension.swift
//  KnackerTemplate
//
//  Created by Nghia Nguyen on 2/11/16.
//  Copyright © 2016 misfit. All rights reserved.
//

import UIKit
import Foundation

public func *(left: String, right: UInt) -> String {
    var result = left
    for _ in 0..<right {
        result += left
    }
    
    return result
}

infix operator ++
public func ++(left: String, right: String) -> String {
    return URL(string: left)?.appendingPathComponent(right).absoluteString ?? ""
}

public extension String {
    enum RXPattern: String {
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        case number = "^[0-9]*?$"
    }
    
    public var nk_uppercaseFirstCharacter: String {
        var string = self
        if string.count < 1 {
            return ""
        }
        
        let range = string.startIndex...string.startIndex
        string.replaceSubrange(range, with: string[0..<1].uppercased())
        return string
    }
    
    public subscript(r: Range<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: min(self.count, r.lowerBound))
        let endIndex = self.index(self.startIndex, offsetBy: min(self.count, r.upperBound))
        
        return String(self[startIndex..<endIndex])
    }
    
    public func nk_match(pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, count)) != nil
        } catch {
            return false
        }
    }
    
    public func nk_removeFirstSubstring(substring: String) -> String {
        var result = self
        
        if let range = result.range(of: substring) {
            result.removeSubrange(range)
        }
        
        return result
    }
    
    public func nk_removeSubstring(substring: String) -> String {
        var result = self
        while let range = result.range(of: substring) {
            result.removeSubrange(range)
        }
        
        return result
    }
}

public extension String {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

public extension String {
    public var nk_isEmail: Bool {
        return self.nk_match(pattern: RXPattern.email.rawValue)
    }
    
    public var nk_isNumber: Bool {
        return self.nk_match(pattern: RXPattern.number.rawValue)
    }
}

public extension String {
    public func nk_heightWithWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return actualSize.height
    }
}

public extension NSAttributedString {
    public func nk_heightWithWidth(width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
        return actualSize.height
    }
}


public extension String {
    public func nk_isGreaterVersion(version: String) -> Bool {
        let newVersions = self.nk_versionValues
        let num = newVersions.count
        let oldVersions = version.nk_versionValues
        
        var equalNum = 0
        for i in 0..<num {
            if newVersions[i] < oldVersions[i] {
                return false
            }
            
            if newVersions[i] == oldVersions[i] {
                equalNum += 1
            }
        }
        
        return equalNum < num
    }
    
    public var nk_versionValues: [Int] {
        let num = 3
        let strings = self.components(separatedBy: ".")
        
        var result = [Int]()
        strings.forEach { s in
            result.append(Int(s) ?? 0)
        }
        
        while result.count < num {
            result.append(0)
        }
        
        return result
    }
}
