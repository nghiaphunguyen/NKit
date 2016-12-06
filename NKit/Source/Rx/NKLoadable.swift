//
//  NSObject+Rx.swift
//  FastSell
//
//  Created by Nghia Nguyen on 9/21/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import Foundation
import RxSwift

public protocol NKLoadable {
    var rx_isLoading: Variable<Bool> {get}
    var rx_error: Variable<ErrorType?> {get}
    
    var errorObservable: Observable<ErrorType> {get}
    var isLoadingObservable: Observable<Bool> {get}
    
    var canLoadDataObservable: Observable<Void> {get}
    
    func setupBeforeLoading()
    func resetAfterDone()
    
    func load<T>(observable: Observable<T>) -> Observable<T>
}

public extension NKLoadable {
    
    public func load<T>(observable: Observable<T>) -> Observable<T> {
        return self.canLoadDataObservable
            .flatMapLatest({_ in observable})
            .nk_doOnNextOrError({self.resetAfterDone()})
            .doOnError({self.rx_error.value = $0})
    }
    
    public func setupBeforeLoading() {
        self.rx_isLoading.value = true
    }
    
    public func resetAfterDone() {
        self.rx_isLoading.value = false
    }
    
    public var isLoadingObservable: Observable<Bool> {
        return self.rx_isLoading.asObservable()
    }
    
    public var errorObservable: Observable<ErrorType> {
        return self.rx_error.asObservable().nk_unwrap()
    }
    
    public var canLoadDataObservable: Observable<Void> {
        return self.isLoadingObservable
            .take(1)
            .filter({$0 == false})
            .map {_ in return}
    }
}
