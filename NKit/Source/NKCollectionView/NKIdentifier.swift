//
//  NKIdentifier.swift
//  IgListKitExample
//
//  Created by Nghia Nguyen on 1/26/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import Foundation

public protocol NKIdentifier {
    static var identifier: String {get}
}

extension NKIdentifier {
    public static var identifier: String {return "\(self)"}
}
