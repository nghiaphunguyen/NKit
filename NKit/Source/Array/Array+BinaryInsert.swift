//
//  Array+BinaryInsert.swift
//  FastSell
//
//  Created by Nghia Nguyen on 8/11/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import Foundation

public extension Array {
    public mutating func nk_removeFirstElement(condition: (element: Element) -> Bool) {
        if let index = self.indexOf(condition) {
            self.removeAtIndex(index)
        }
    }
    
    public mutating func nk_removeElements(condition: (element: Element) -> Bool) {
        while let index = self.indexOf(condition) {
            self.removeAtIndex(index)
        }
    }
    
    public mutating func nk_binaryInsert(element: Element, comparation:
        (element1: Element, element2: Element) -> Bool) {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi) / 2
            if comparation(element1: self[mid], element2: element) {
                lo = mid + 1
            } else {
                hi = mid - 1
            }
        }
        
        self.insert(element, atIndex: lo)
    }
}