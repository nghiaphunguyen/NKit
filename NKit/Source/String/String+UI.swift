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
    public func nk_strikeThrough(style: NSUnderlineStyle = .thick, color: UIColor? = nil) -> NSMutableAttributedString {
        let string = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.strikethroughStyle: style.rawValue])
        
        if let color = color {
            string.addAttribute(NSAttributedString.Key.strikethroughColor, value: color, range: NSMakeRange(0, self.count))
        }
        return string
    }
    
    public func nk_underline(style: NSUnderlineStyle = .single, color: UIColor? = nil) ->  NSMutableAttributedString {
        let string = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.underlineStyle: style.rawValue])
        
        if let color = color {
            string.addAttribute(NSAttributedString.Key.underlineColor, value: color, range: NSMakeRange(0, self.count))
        }
        return string
    }
}

public extension NSMutableAttributedString {
    public func nk_strikeThrough(style: NSUnderlineStyle = .thick, color: UIColor? = nil) -> NSMutableAttributedString {
        let length = self.string.count
        let range = NSMakeRange(0, length)
        self.addAttribute(NSAttributedString.Key.strikethroughStyle, value: style.rawValue, range: range)
        
        if let color = color {
            self.addAttribute(NSAttributedString.Key.strikethroughColor, value: color, range: range)
        }
        return self
    }
    
    public func nk_underline(style: NSUnderlineStyle = .single, color: UIColor? = nil) ->  NSMutableAttributedString {
        let length = self.string.count
        let range = NSMakeRange(0, length)
        self.addAttribute(NSAttributedString.Key.underlineStyle, value: style.rawValue, range: range)
        
        if let color = color {
            self.addAttribute(NSAttributedString.Key.underlineColor, value: color, range: range)
        }
        return self
    }
}
