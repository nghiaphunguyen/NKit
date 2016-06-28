//
//  UIViewController+Rx.swift
//  FastSell
//
//  Created by Nghia Nguyen on 5/16/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import UIKit
import RxSwift
import ObjectiveC

private var NKAssociativeKeyDisposeBag: UInt8 = 0

public extension UIViewController {
    public var nk_disposeBag: DisposeBag {
        get {
            guard let bag = objc_getAssociatedObject(self, &NKAssociativeKeyDisposeBag) as? DisposeBag else {
                let bag = DisposeBag()
                self.nk_disposeBag = bag
                return bag
            }
            
            return bag
        }
        
        set {
            objc_setAssociatedObject(self, &NKAssociativeKeyDisposeBag, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
