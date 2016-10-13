//
//  KillOptional.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/26/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

infix operator ?!
public func ?! <T>(left: T?, right: (T) -> Void){
    if let left = left {
        right(left)
    }
}

public func ?! <T>(left: T?, right: () -> Void){
    if let _ = left {
        right()
    }
}

public func ?! <T, U>(left: (T?, U?), right: (T, U) -> Void) {
    if let t = left.0, let u = left.1 {
        right(t, u)
    }
}

public func ?! <T, U>(left: (T?, U?), right: () -> Void) {
    if let _ = left.0, let _ = left.1 {
        right()
    }
}

public func ?! <T, U, V>(left: (T?, U?, V?), right: (T, U, V) -> Void) {
    if let t = left.0, let u = left.1, let v = left.2 {
        right(t, u, v)
    }
}

public func ?! <T, U, V>(left: (T?, U?, V?), right: () -> Void) {
    if let _ = left.0, let _ = left.1, let _ = left.2 {
        right()
    }
}

public func ?! <T, U, V, X>(left: (T?, U?, V?, X?), right: (T, U, V, X) -> Void) {
    if let t = left.0, let u = left.1, let v = left.2, let x = left.3 {
        right(t, u, v, x)
    }
}

public func ?! <T, U, V, X>(left: (T?, U?, V?, X?), right: () -> Void) {
    if let _ = left.0, let _ = left.1, let _ = left.2, let _ = left.3 {
        right()
    }
}

public func ?! <T, U, V, X, Y>(left: (T?, U?, V?, X?, Y?), right: (T, U, V, X, Y) -> Void) {
    if let t = left.0, let u = left.1, let v = left.2, let x = left.3, let y = left.4 {
        right(t, u, v, x, y)
    }
}

public func ?! <T, U, V, X, Y>(left: (T?, U?, V?, X?, Y?
    ), right: () -> Void) {
    if let _ = left.0, let _ = left.1, let _ = left.2, let _ = left.3, let _ = left.4 {
        right()
    }
}

public func ?! <T, U, V, X, Y, W>(left: (T?, U?, V?, X?, Y?, W?), right: (T, U, V, X, Y, W) -> Void) {
    if let t = left.0, let u = left.1, let v = left.2, let x = left.3, let y = left.4, let w = left.5 {
        right(t, u, v, x, y, w)
    }
}

public func ?! <T, U, V, X, Y, W>(left: (T?, U?, V?, X?, Y?, W?), right: () -> Void) {
    if let _ = left.0, let _ = left.1, let _ = left.2, let _ = left.3, let _ = left.4, let _ = left.5 {
        right()
    }
}
