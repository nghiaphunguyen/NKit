//
//  NKRowAction.swift
//  NKit
//
//  Created by Apple on 3/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

open class NKRowAction<T>: NKBaseRowAction {
    open let sender: AnyObject?
    open let indexPath: IndexPath
    open let value: T
    
    public init?(payload: Any?, sender: AnyObject?, indexPath: IndexPath?) {
        guard let indexPath = indexPath else {return nil}
        guard let payload = payload as? T else {return nil}
        self.value = payload
        self.sender = sender
        self.indexPath = indexPath
    }
}
