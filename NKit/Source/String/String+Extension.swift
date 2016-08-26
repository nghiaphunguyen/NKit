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
    public subscript(r: Range<Int>) -> String {
        let startIndex = self.startIndex.advancedBy(min(self.characters.count, r.startIndex))
        let endIndex = self.startIndex.advancedBy(min(self.characters.count, r.endIndex))
        
        return self[startIndex..<endIndex]
    }
}

public extension String {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

public extension String {
    public var isValidEmail: Bool {
        if self.characters.count == 0 {
            return false
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(self)
        
        return result
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
