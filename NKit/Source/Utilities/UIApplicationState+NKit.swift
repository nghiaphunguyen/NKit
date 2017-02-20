//
//  UIApplicationState+NKit.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/20/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit


public extension UIApplicationState {
    public var nk_desc: String {
        switch self {
        case .active:
            return "Active"
        case .background:
            return "Background"
        case .inactive:
            return "Inactive"
        }
    }
}
