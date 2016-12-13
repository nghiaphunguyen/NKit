//
//  Array+Extension.swift
//  NKit
//
//  Created by Nghia Nguyen on 12/6/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import NRxSwift

public extension Array where Element: NKOptional {
    public var nk_unwrap: Array<Element.Wrapped> {
        return self.filter {$0.value != nil}.map {$0.value!}
    }
}

public extension Array {
    public var nk_any: [Any] {
        return self.map {$0 as Any}
    }
    
    public func nk_firstMap(_ condition: (Element) -> Bool) -> Element? {
        for e in self {
            if condition(e) {
                return e
            }
        }
        
        return nil
    }
}

public extension Array where Element: Any {
    public func nk_cast<T>() -> [T] {
        return self.map {$0 as? T}.nk_unwrap
    }
}
