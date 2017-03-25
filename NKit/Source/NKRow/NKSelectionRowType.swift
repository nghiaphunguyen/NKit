//
//  SelectionRowType.swift
//  Dealer
//
//  Created by Nghia Nguyen on 3/16/17.
//  Copyright © 2017 Replaid Pte Ltd. All rights reserved.
//

import UIKit
import RxSwift

public protocol NKSelectionRowType: NKBaseRowType {
    var selectSubject: PublishSubject<Void> {get}
}
