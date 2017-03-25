//
//  NKCallbackable.swift
//  NKit
//
//  Created by Apple on 3/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKCallbackable {
    var callback: ((Any?) -> Void)? {get set}
}
