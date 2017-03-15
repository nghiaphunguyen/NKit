//
//  NKAnyMiniReducable.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/15/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKAnyMiniReducable {
    func _handleAction(_ action: NKAction, withState state: Any) -> Any
}
