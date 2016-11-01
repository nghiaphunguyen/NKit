//
//  Optional+NKit.swift
//  NKit
//
//  Created by Nghia Nguyen on 11/1/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

public extension Optional {
    public var nk_isNil: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
    
    public var nk_isNotNil: Bool {
        switch self {
        case .none:
            return false
        default:
            return true
        }
    }
}
