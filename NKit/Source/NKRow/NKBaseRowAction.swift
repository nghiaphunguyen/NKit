//
//  NKBaseRowAction.swift
//  NKit
//
//  Created by Apple on 3/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKBaseRowAction: NKAction {
    var indexPath: IndexPath {get}
}

