//
//  Dwifft+BasicType.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/6/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import Foundation

extension String: NKDiffable {
    public var diffIdentifier: String {
        return self
    }
}

extension Int: NKDiffable {
    public var diffIdentifier: String {
        return self.nk_string
    }
}

extension Double: NKDiffable {
    public var diffIdentifier: String {
        return self.nk_string
    }
}
