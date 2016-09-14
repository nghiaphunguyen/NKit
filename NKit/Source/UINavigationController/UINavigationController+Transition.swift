//
//  UINavigationController+Transition.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/13/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

private struct Identifier {
    static var Transition: UInt8 = 0
}

public extension UINavigationController {
    public var nk_transition: NKNavigationTransition {
        if self._nk_transition == nil {
            self._nk_transition = NKNavigationTransition()
        }
        
        return self._nk_transition!
    }
}

extension UINavigationController {
    var _nk_transition: NKNavigationTransition? {
        get {
            return objc_getAssociatedObject(self, &Identifier.Transition) as? NKNavigationTransition
        }
        
        set {
            objc_setAssociatedObject(self, &Identifier.Transition, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}