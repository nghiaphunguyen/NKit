//
//  Array+NKStyle.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/7/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

struct NKArrayStylable: NKStylable {
    let array: [NKStylable]
    
    func style(_ model: Any) {
        array.forEach({
            $0.style(model)
        })
    }
}

public extension Array where Element: NKStylable {
    public func nk_union() -> NKStylable {
        return NKArrayStylable(array: self)
    }
}
