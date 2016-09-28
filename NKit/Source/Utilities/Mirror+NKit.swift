//
//  Mirror+NKit.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

public extension Mirror {
    public subscript(name: String) -> Any?  {
        for child in children {
            if child.label == name {
                return child.value
            }
        }
        
        return nil
    }
}

