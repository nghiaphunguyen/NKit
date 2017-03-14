//
//  NKActionDelegable.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/14/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift

public protocol NKActionDelegable {
    var handleActionObservable: Observable<NKAction> {get}
    func `do`(action: NKAction)
}
