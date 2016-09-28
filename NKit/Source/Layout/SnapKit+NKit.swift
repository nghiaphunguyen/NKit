//
//  ConstraintItem+NKit.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import SnapKit

public extension ConstraintItem {
    public var nk_view: UIView {
        let mirror = Mirror(reflecting: self)
        return mirror["object"] as! UIView
    }
}

public extension ConstraintMaker {
    public var nk_view: UIView {
        let mirror = Mirror(reflecting: self)
        return mirror["view"] as! UIView
    }
}
