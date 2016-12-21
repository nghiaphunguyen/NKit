//
//  PullingViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/11/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import NRxSwift

public protocol NKPullingViewModel: NKLoadable, NKPullingReactor {
    associatedtype LoadingModel
    associatedtype StateLoadingModel
    
    var rx_loadingModels: Variable<[StateLoadingModel]> {get}
    
    var page: Int {get set}
    var initPage: Int {get}
    var isLoadMore: Bool {get set}
    
    func loadMore()
    func refresh()
    
    func doSomethingBeforeLoadingModels() -> Observable<Void>
    func doSomethingAfterLoadLoadingModels(models: [LoadingModel]) -> Observable<[LoadingModel]>
    
    func pull(page: Int) -> Observable<[LoadingModel]> // need override
    func map(value: [LoadingModel]) -> [StateLoadingModel] //need override
}

public extension NKPullingViewModel where Self: NSObject {
    public var loadingModels: NKVariable<[StateLoadingModel]> {
        return self.rx_loadingModels.nk_variable
    }
    
    public func doSomethingBeforeLoadingModels() -> Observable<Void>{
        return Observable.just(Void())
    }
    
    public func doSomethingAfterLoadLoadingModels(models: [LoadingModel]) -> Observable<[LoadingModel]> {
        return Observable.just(models)
    }
    
    public func loadMore() {
        let strongSelf = self
        strongSelf.load(self.pullData())
            .subscribe()
            .addDisposableTo(self.nk_disposeBag)
    }
    
    public func refresh() {
        let strongSelf = self
        strongSelf.load(
            Observable<Void>.nk_from(strongSelf.resetModel)
                .flatMapLatest({_ in strongSelf.pullData()})
            )
            .subscribe()
            .addDisposableTo(self.nk_disposeBag)
    }
    
    private func resetModel() {
        var strongSelf = self
        strongSelf.rx_loadingModels.value = []
        strongSelf.isLoadMore = true
        strongSelf.page = self.initPage
    }
    
    private func canLoadMore() -> Observable<Void> {
        return Observable.nk_baseCreate({ (observer ) in
            if self.isLoadMore {
                observer.nk_setValue()
            }
        })
    }
    
    private func pullData() -> Observable<[LoadingModel]> {
        var strongSelf = self
        return strongSelf
            .canLoadMore()
            .flatMapLatest({_ in strongSelf.doSomethingBeforeLoadingModels()})
            .flatMapLatest({_ in strongSelf.pull(page: strongSelf.page)})
            .flatMapLatest({strongSelf.doSomethingAfterLoadLoadingModels(models: $0)})
            .do(onNext: {
                let value = strongSelf.map(value: $0)
                strongSelf.isLoadMore = !(value.count == 0)
                strongSelf.changeLoadingModels(value: $0)
                strongSelf.page = strongSelf.page + 1
            })
        
    }
    
    private func changeLoadingModels(value: [LoadingModel]) {
        let value = map(value: value)
        self.rx_loadingModels.value += value
    }
}

