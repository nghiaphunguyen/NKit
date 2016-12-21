//
//  PullingViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 12/20/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import NRxSwift

public protocol NKPullingAction {
    func refresh()
    func loadMore()
    func clearError()
}

public protocol NKPullingState {
    associatedtype StateLoadingModel
    var loadingModels: NKVariable<[StateLoadingModel]> {get}
    var error: NKVariable<Error?> {get}
    var isLoading: NKVariable<Bool> {get}
}

public typealias NKPullingReactor = NKPullingAction & NKPullingState
