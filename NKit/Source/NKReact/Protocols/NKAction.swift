//
//  NKAction.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/14/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKAction {
    var sender: AnyObject? {get}
}

public extension NKAction {
    public var sender: AnyObject? {
        return nil
    }
    
    public func isEqualSender(_ sender: AnyObject?) -> Bool {
        return self.sender != nil && self.sender === sender
    }
}
