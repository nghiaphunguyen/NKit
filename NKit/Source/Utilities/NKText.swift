//
//  NKText.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/30/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

public protocol NKText {
    var rawValue: String {get}
    var text: String {get}
}

public extension NKText {
    public var text: String {
        return NSLocalizedString("\(self.rawValue)", comment: "")
    }
}