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

open class NKRowAction<T>: NKBaseRowAction {
    open let sender: AnyObject?
    open let indexPath: IndexPath
    open let value: T!
    
    public init?(payload: Any?, sender: AnyObject?, indexPath: IndexPath?) {
        
        guard let indexPath = indexPath else {return nil}
        
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
        self.indexPath = indexPath
    }
}
