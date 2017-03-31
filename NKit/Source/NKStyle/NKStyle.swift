//
//  NKStyle.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/7/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public func >> <T>(left: T.Type, right: @escaping (T) -> Void) -> NKStylable {
    return NKStyle<T>.init(config: right)
}

public struct NKStyle<T>: NKStylable {
    let config: (T) -> Void
    
    public init(config: @escaping (T) -> Void) {
        self.config = config
    }
    
    public func style(_ model: Any) {
        guard let model = model as? T else {return}
        self.config(model)
    }
}
