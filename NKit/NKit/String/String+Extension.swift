//
//  String+Extension.swift
//  KnackerTemplate
//
//  Created by Nghia Nguyen on 2/11/16.
//  Copyright © 2016 misfit. All rights reserved.
//

import Foundation

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
