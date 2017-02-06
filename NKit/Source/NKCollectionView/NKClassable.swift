//
//  NKClassable.swift
//  IgListKitExample
//
//  Created by Nghia Nguyen on 1/26/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import Foundation

public protocol NKClassable {
    var classType: AnyClass.Type {get}
}
