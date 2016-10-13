//
//  Array+BinaryInsert.swift
//  FastSell
//
//  Created by Nghia Nguyen on 8/11/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import Foundation

public extension Array {
    public mutating func nk_removeFirstElement(condition: (_ element: Element) -> Bool) {
        if let index = self.index(where: condition) {
            self.remove(at: index)
        }
    }
    
    public mutating func nk_removeElements(condition: (_ element: Element) -> Bool) {
        while let index = self.index(where: condition) {
            self.remove(at: index)
        }
    }
    
    public mutating func nk_binaryInsert(element: Element, comparation:
        (_ element1: Element, _ element2: Element) -> Bool) {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi) / 2
            if comparation(self[mid], element) {
                lo = mid + 1
            } else {
                hi = mid - 1
            }
        }
        
        self.insert(element, at: lo)
    }
}
