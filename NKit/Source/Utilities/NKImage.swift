//
//  NKImage.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/30/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKImage {
    var rawValue: String {get}
    var image: UIImage {get}
}

public extension NKImage {
    public var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}