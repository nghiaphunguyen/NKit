//
//  NKReducable.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/14/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKAnyReducable {
    func _handle(action: NKAction, state: Any) -> Any
}
