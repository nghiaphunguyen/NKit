//
//  NSObject+Rx.swift
//  FastSell
//
//  Created by Nghia Nguyen on 9/21/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import Foundation
import RxSwift
import NRxSwift

public protocol NKLoadable {
    var rx_isLoading: Variable<Bool> {get}
    var isLoading: NKVariable<Bool> {get}
    
    var rx_error: Variable<Error?> {get}
    var error: NKVariable<Error?> {get}
    
    func clearError()
    
    func setupBeforeLoading()
    func resetAfterDone()
    
    func load<T>(_ observable: Observable<T>) -> Observable<T>
}

public extension NKLoadable {
    
    public func clearError() {
        self.rx_error.value = nil
    }
    
    public func load<T>(_ observable: Observable<T>) -> Observable<T> {
        return self.canLoadDataObservable
            .do(onNext: {self.setupBeforeLoading()})
            .flatMapLatest({_ in observable})
            .nk_doOnNextOrCompleteOrError({self.resetAfterDone()})
            .do(onError: {self.rx_error.value = $0})
    }
    
    public func setupBeforeLoading() {
        self.rx_isLoading.value = true
    }
    
    public func resetAfterDone() {
        self.rx_isLoading.value = false
    }
    
    public var isLoading: NKVariable<Bool> {
        return self.rx_isLoading.nk_variable
    }
    
    public var error: NKVariable<Error?> {
        return self.rx_error.nk_variable
    }
    
    private var canLoadDataObservable: Observable<Void> {
        return self.rx_isLoading.asObservable().take(1).filter({$0 == false}).map {_ in return}
//        return Observable.nk_baseCreate({ (observer) in
//            print("Loading = \(self.rx_isLoading.value)")
//            if self.rx_isLoading.value == false {
//                observer.nk_setValue()
//            }
//        })
    }
}
