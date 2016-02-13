//
//  String+Extension.swift
//  KnackerTemplate
//
//  Created by Nghia Nguyen on 2/11/16.
//  Copyright © 2016 misfit. All rights reserved.
//

import Foundation

infix operator ++ {}
public func ++(left: String, right: String) -> String {
    return (left as NSString).stringByAppendingPathComponent(right)
}