//
//  NKTableViewCellDatasource.swift
//  NKit
//
//  Created by Nghia Nguyen on 4/18/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import Foundation

public protocol NKTableViewCellDataSource: NSObjectProtocol {
    typealias NKCellModel
    static func cellIdentifier() -> String //default is class name
    func heightCellWithModel(model: NKCellModel) -> CGFloat //default is UITableAuto..
    func configCellWithModel(model: NKCellModel) -> Void
}

