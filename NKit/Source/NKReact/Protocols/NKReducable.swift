//
//  NKTReducable.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/14/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKReducable: NKAnyReducable {
    associatedtype T: NKState
    func handleAction(_ action: NKAction, withState state: T?) -> T
}

public extension NKReducable {
    public func _handleAction(_ action: NKAction, withState state: NKState?) -> NKState {
        if let state = state as? T {
            return self.handleAction(action, withState: state)
        }
        
        return T()
    }
}
