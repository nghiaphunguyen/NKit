//
//  NKNotificationProxy.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKNotificationProxyable {
    mutating func add(handler: NKNotificationHandlable.Type)
    mutating func remove(handler: NKNotificationHandlable.Type)
    func getNotificationHandler(withJSON json: [AnyHashable: Any]) -> NKNotificationHandlable?
}
