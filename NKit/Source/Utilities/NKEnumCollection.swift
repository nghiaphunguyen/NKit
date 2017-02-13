//
//  NKEnumCollection.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/13/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import Foundation

public protocol NKEnumCollection : Hashable {}
public extension NKEnumCollection {
    static var all: [Self] {
        typealias S = Self
        
        return Array(AnySequence { () -> AnyIterator<S> in
            var raw = 0
            return AnyIterator {
                let current : Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        })
    }
}
