//
//  Double+Random.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/26/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

public extension Int {
    private struct Dummy {
        static var Template: String {return "This is a protoype string"}
    }
    
    public var nk_dummyString: String {
        let templateCount = Dummy.Template.characters.count
        let times = UInt((self / templateCount) + 1)
        return (Dummy.Template * times)[0..<self]
    }
    
    public var nk_dummyNumber: String {
        var result = ""
        for _ in 0..<self {
            result += "\(arc4random() % 10)"
        }
        
        return result
    }
}
