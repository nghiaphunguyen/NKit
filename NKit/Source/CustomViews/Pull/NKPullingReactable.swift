//
//  PullingViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 12/20/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import NRxSwift
import RxSwift

public protocol NKPullingAction {
    func refresh()
    func loadMore()
    func clearError()
}

public protocol NKPullingState {
    var viewModels: NKVariable<[NKDiffable]> {get}
    var errorString: NKVariable<String?> {get}
    var isLoadMore: NKVariable<Bool> {get}
    
    var shouldShowLoadingObseravble: Observable<Bool> {get}
    var shouldShowEmptyViewObservable: Observable<Bool> {get}
    var shouldShowErrorViewObservable: Observable<Bool> {get}
    var shouldShowErrorPopupViewObservable: Observable<Bool> {get}
    var shouldShowListViewObservable: Observable<Bool> { get }
}
