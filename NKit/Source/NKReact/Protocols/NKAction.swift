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
    var identifier: String? {get}
}

public extension NKAction {
    public var sender: AnyObject? {
        return nil
    }
    
    public var identifier: String? {
        return nil
    }
    
    public func isEqualSender(_ sender: AnyObject?) -> Bool {
        return self.sender != nil && self.sender === sender
    }
    
    public func value<T>(identifier: String?) -> T? {
        guard self.identifier != nil && self.identifier == identifier else {
            return nil
        }
        
        guard let action = self as? NKBaseAction<T> else {return nil}
        
        return action.value
    }
}
