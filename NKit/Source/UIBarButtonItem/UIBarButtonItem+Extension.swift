//
//  UIBarButtonItem+Extension.swift
//  FastSell
//
//  Created by Nghia Nguyen on 5/30/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    public var nk_view: UIView? {
        return self.value(forKeyPath: "view") as? UIView
    }
}

