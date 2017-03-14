//
//  NKTReducable.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/14/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKTReducable: NKReducable {
    associatedtype T: NKState
    func handleTAction<T: NKState>(_ action: NKAction, withState: T) -> T
}

public extension NKTReducable {
    public func handleAction(_ action: NKAction, withState state: NKState) -> NKState {
        if let state = state as? T {
            return self.handleTAction(action, withState: state)
        }
        
        return T()
    }
}
