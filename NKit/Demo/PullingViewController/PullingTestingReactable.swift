//
//  PullingTestingReactable.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/19/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import NRxSwift

protocol PullingTestingState: NKPullingState {
    
}

protocol PullingTestingAction: NKPullingAction {
    
}

protocol PullingTestingReactable {
    var state: PullingTestingState {get}
    var action: PullingTestingAction {get}
}


