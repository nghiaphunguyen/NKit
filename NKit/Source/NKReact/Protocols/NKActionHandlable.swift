//
//  NKActionHandlable.swift
//  NKit
//
//  Created by Apple on 3/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit


public protocol NKActionHandlable {
    var actionHub: NKActionDelegable {get}
    var sender: AnyObject? {get}
    func setupActionHandler()
    func handle(action: NKAction)
}

extension NKActionHandlable where Self: NSObject {
    public func setupActionHandler() {
        self.actionHub.handleActionObservable.filter {[weak self] in $0.isEqualSender(self?.sender) == true
            }.nk_subscribe { (action) in
            self.handle(action: action)
            }.addDisposableTo(self.nk_disposeBag)
    }
}
