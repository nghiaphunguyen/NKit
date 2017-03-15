//
//  NKMiniReducable.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/14/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKMiniReducable: NKAnyMiniReducable {
    associatedtype T
    func handleAction(_ action: NKAction, withState state: T) -> T
}

extension NKMiniReducable {
    public func _handleAction(_ action: NKAction, withState state: Any) -> Any {
        if let state = state as? T {
            return self.handleAction(action, withState: state)
        }
        
        return state
    }
}
