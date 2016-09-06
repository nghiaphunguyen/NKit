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

infix operator ++ {}
public func ++(left: String, right: String) -> String {
    return (left as NSString).stringByAppendingPathComponent(right)
}

public extension String {
    private enum RXPattern: String {
        case Email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        case Number = "^[0-9]*?$"
    }
    
    public var nk_uppercaseFirstCharacter: String {
        var string = self
        if string.characters.count < 1 {
            return ""
        }
        
        string.replaceRange(string.startIndex...string.startIndex, with: string[0...0].uppercaseString)
        return string
    }
    
    public subscript(r: Range<Int>) -> String {
        let startIndex = self.startIndex.advancedBy(min(self.characters.count, r.startIndex))
        let endIndex = self.startIndex.advancedBy(min(self.characters.count, r.endIndex))
        
        return self[startIndex..<endIndex]
    }
    
    public func nk_match(pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, characters.count)) != nil
        } catch {
            return false
        }
    }
    
    public func nk_removeFirstSubstring(substring: String) -> String {
        var result = self
        if let range = result.rangeOfString(substring) {
            result.removeRange(range)
        }
        
        return result
    }
    
    public func nk_removeSubstring(substring: String) -> String {
        var result = self
        while let range = result.rangeOfString(substring) {
            result.removeRange(range)
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
        return self.nk_match(RXPattern.Email.rawValue)
    }
    
    public var nk_isNumber: Bool {
        return self.nk_match(RXPattern.Number.rawValue)
    }
}

public extension String {
    public func nk_heightWithWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.max)
        let actualSize = self.boundingRectWithSize(maxSize, options: [.UsesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: nil)
        return actualSize.height
    }
}

public extension NSAttributedString {
    public func nk_heightWithWidth(width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.max)
        let actualSize = boundingRectWithSize(maxSize, options: [.UsesLineFragmentOrigin], context: nil)
        return actualSize.height
    }
}
