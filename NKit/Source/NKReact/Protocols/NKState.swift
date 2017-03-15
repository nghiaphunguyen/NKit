//
//  NKState.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/14/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKState {
    init()
    func to<T: NKState>(_ type: T.Type) -> T
}

public extension NKState {
    public func to<T: NKState>(_ type: T.Type) -> T {
        if let state = self as? T {
            return state
        }
        
        return T()
    }
}

public extension Optional where Wrapped: NKState {
    public func nk_unwrap() -> Wrapped {
        switch self {
        case .none:
            return Wrapped()
        case .some(let value):
            return value
        }
    }
}
