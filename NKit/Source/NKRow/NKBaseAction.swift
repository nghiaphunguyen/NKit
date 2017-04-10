//
//  NKRowAction.swift
//  NKit
//
//  Created by Apple on 3/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

protocol NKOptional2 {}

extension Optional: NKOptional2 {}

open class NKBaseAction<T>: NKAction {
    open let sender: AnyObject?
    open let identifier: NKActionIdentifier?
    open let value: T?
    
    public init?(payload: Any?, sender: AnyObject?, identifier: NKActionIdentifier?) {
        
        if payload == nil {
            guard T.self is NKOptional2.Type else {
                return nil
            }
            
            self.value = nil
        } else {
            guard let payload = payload as? T else {
                return nil
            }
            
            self.value = payload
        }
        
        self.sender = sender
        self.identifier = identifier
    }
}
