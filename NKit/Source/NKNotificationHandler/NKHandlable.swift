//
//  NKNotificationHandlable.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKHandlable {
    init?(payload: Any)
    func execute()
}
