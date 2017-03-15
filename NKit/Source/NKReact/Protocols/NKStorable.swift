//
//  NKStore.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/14/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import NRxSwift
import RxSwift

public protocol NKStorable {
    associatedtype StateType
    var state: NKVariable<StateType> {get}
    var reducer: NKAnyReducable {get}
    func `do`(action: NKAction)
}
