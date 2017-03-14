//
//  NKStore.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/14/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import NRxSwift

public final class NKStore<StateType: NKState>: NKStorable {
    private let rx_state = Variable<StateType>(StateType())
    public var state: NKVariable<StateType> {
        return self.rx_state.nk_variable
    }
    
    public let reducer: NKReducable
    
    public init(reducer: NKReducable) {
        self.reducer = reducer
    }
    
    public func `do`(action: NKAction) {
        if let state = self.reducer.handleAction(action, withState: self.rx_state.value) as? StateType {
            self.rx_state.value = state
        }
    }
}
