//
//  NKTReducable.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/14/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKReducable: NKAnyReducable {
    associatedtype T
    func handle(action: NKAction, state: T) -> T
}

public extension NKReducable {
    
    public func _handle(action: NKAction, state: Any) -> Any {
        if let state = state as? T {
            return self.handle(action: action, state: state)
        }
        
        return state
    }
}
