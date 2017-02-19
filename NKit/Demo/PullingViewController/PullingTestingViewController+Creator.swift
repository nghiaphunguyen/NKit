//
//  PullingTestingViewController+Creator.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/19/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import NRxSwift

extension PullingTestingViewController {
    static var testingInstance: PullingTestingViewController {
        return PullingTestingViewController()
    }
    
    static var instance: PullingTestingViewController {
        return PullingTestingViewController.init(pullingViewModel: PullingTestingReactor())
    }
}
