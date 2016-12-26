//
//  NKDemension.swift
//  NKit
//
//  Created by Nghia Nguyen on 8/26/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

public struct NKDimension: OptionSet {
    public let rawValue: Int
    
    public static let Width = NKDimension(rawValue: 1)
    public static let Height = NKDimension(rawValue: 2)
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
