//
//  String+UI.swift
//  NKit
//
//  Created by Nghia Nguyen on 12/7/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    public func nk_strikeThrough(style: NSUnderlineStyle = .styleThick, color: UIColor? = nil) -> NSMutableAttributedString {
        let string = NSMutableAttributedString(string: self, attributes: [NSStrikethroughStyleAttributeName: style.rawValue])
        
        if let color = color {
            string.addAttribute(NSStrikethroughColorAttributeName, value: color, range: NSMakeRange(0, self.characters.count))
        }
        return string
    }
    
    public func nk_underline(style: NSUnderlineStyle = .styleSingle, color: UIColor? = nil) ->  NSMutableAttributedString {
        let string = NSMutableAttributedString(string: self, attributes: [NSUnderlineStyleAttributeName: style.rawValue])
        
        if let color = color {
            string.addAttribute(NSUnderlineColorAttributeName, value: color, range: NSMakeRange(0, self.characters.count))
        }
        return string
    }
}

public extension NSMutableAttributedString {
    public func nk_strikeThrough(style: NSUnderlineStyle = .styleThick, color: UIColor? = nil) -> NSMutableAttributedString {
        let length = self.string.characters.count
        let range = NSMakeRange(0, length)
        self.addAttribute(NSStrikethroughStyleAttributeName, value: style.rawValue, range: range)
        
        if let color = color {
            self.addAttribute(NSStrikethroughColorAttributeName, value: color, range: range)
        }
        return self
    }
    
    public func nk_underline(style: NSUnderlineStyle = .styleSingle, color: UIColor? = nil) ->  NSMutableAttributedString {
        let length = self.string.characters.count
        let range = NSMakeRange(0, length)
        self.addAttribute(NSUnderlineStyleAttributeName, value: style.rawValue, range: range)
        
        if let color = color {
            self.addAttribute(NSUnderlineColorAttributeName, value: color, range: range)
        }
        return self
    }
}
