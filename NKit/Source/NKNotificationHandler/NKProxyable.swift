//
//  NKNotificationProxy.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKProxyable {
    mutating func add(handler: NKHandlable.Type)
    mutating func remove(handler: NKHandlable.Type)
    func getHandler(withPayload payload: Any) -> NKHandlable?
}
