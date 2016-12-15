//
//  NKColor.swift
//  NKit
//
//  Created by Nghia Nguyen on 12/13/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKColor {
    var rawValue: Int {get}
    var color: UIColor {get}
}

public extension NKColor {
    public var color: UIColor {
        return UIColor.init(hex: self.rawValue)
    }
}
