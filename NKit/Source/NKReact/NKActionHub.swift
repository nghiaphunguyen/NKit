//
//  NKActionHub.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/14/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift

public final class NKActionHub: NKActionDelegable {
    
    private var handleActionSubject = PublishSubject<NKAction>()
    
    public var handleActionObservable: Observable<NKAction> {
        return self.handleActionSubject.asObservable()
    }
    
    public func `do`(action: NKAction) {
        self.handleActionSubject.onNext(action)
    }
}
