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
    func canHandle(action: NKAction) -> Bool
    func setupActionHandler()
    func handle(action: NKAction)
}

public extension NKActionHandlable where Self: NSObject {
    public func setupActionHandler() {
        self.actionHub.handleActionObservable.filter {[weak self] in
            return self?.canHandle(action: $0) == true
            }.nk_subscribe {[weak self] (action) in
            self?.handle(action: action)
            }.addDisposableTo(self.nk_disposeBag)
    }
}
