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

public extension NKLoadable where Self: AnyObject {
    
    public func clearError() {
        if self.rx_error.value != nil {
            self.rx_error.value = nil
        }
    }
    
    public func load<T>(_ observable: Observable<T>) -> Observable<T> {
        return self.canLoadDataObservable
            .do(onNext: {[unowned self] in self.setupBeforeLoading()})
            .flatMapLatest({_ in observable})
            .nk_doOnNextOrError({[unowned self] in self.resetAfterDone()})
            .do(onError: {[unowned self] in self.rx_error.value = $0})
    }
    
    public func setupBeforeLoading() {
        if self.rx_isLoading.value != true {
            self.rx_isLoading.value = true
        }
        
    }
    
    public func resetAfterDone() {
        if self.rx_isLoading.value != false {
            self.rx_isLoading.value = false
        }
    }
    
    public var isLoading: NKVariable<Bool> {
        return self.rx_isLoading.nk_variable
    }
    
    public var error: NKVariable<Error?> {
        return self.rx_error.nk_variable
    }
    
    private var canLoadDataObservable: Observable<Void> {
        return self.rx_isLoading.asObservable().take(1).filter({$0 == false}).map {_ in return}
    }
}
