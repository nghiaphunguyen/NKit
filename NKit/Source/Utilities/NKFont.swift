//
//  NKFont.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/30/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKFont {
    var rawValue: String {get}
    
    func font(size: CGFloat) -> UIFont
}

public extension NKFont {
    public func font(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
