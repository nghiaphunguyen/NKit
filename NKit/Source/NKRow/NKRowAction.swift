//
//  NKRowAction.swift
//  NKit
//
//  Created by Apple on 3/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public class RowAction<T>: NKBaseRowAction {
    public let sender: AnyObject
    public let indexPath: IndexPath
    public let value: T
    
    public init?(payload: Any?, sender: AnyObject?, indexPath: IndexPath?) {
        guard let indexPath = indexPath else {return nil}
        guard let payload = payload as? T else {return nil}
        guard let sender = sender else {return nil}
        self.value = payload
        self.sender = sender
        self.indexPath = indexPath
    }
}
