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

public protocol NKPullingViewModelable: NKLoadable, NKPullingState, NKPullingAction {
    //MARK: need override
    var rx_items: Variable<[NKDiffable]> {get}
    var rx_isLoadMore: Variable<Bool> {get}
    var page: Int {get set}
    var initPage: Int {get}
    
    // pull items from ouside source
    func pull(page: Int) -> Observable<[Any]>
    
    // Mapping from pulling items to view model items
    func map(value: [Any]) -> [NKDiffable]
    
    //MARK: Optional
    func doSomethingBeforeLoadingModels() -> Observable<Void>
    func doSomethingAfterLoadLoadingModels(models: [Any]) -> Observable<[Any]>
}

public extension NKPullingViewModelable where Self: NSObject {
    //MARK: NKPullingState
    public var items: NKVariable<[NKDiffable]> {
        return self.rx_items.nk_variable
    }
    
    public var isLoadMore: NKVariable<Bool> {
        return self.rx_isLoadMore.nk_variable
    }
    
    public var shouldShowLoadingObseravble: Observable<Bool> {
        return Observable.combineLatest(self.rx_items.asObservable(), self.rx_isLoading.asObservable(), resultSelector: { (item, loading) -> Bool in
            return item.count == 0 && loading == true
        })
    }
    
    public var shouldShowEmptyViewObservable: Observable<Bool> {
        return Observable.combineLatest(self.rx_items.asObservable(), self.rx_isLoading.asObservable(), self.rx_error.asObservable(), resultSelector: { (items, loading, error) -> Bool in
            return items.count == 0 && loading == false && error == nil
        })
    }
    
    public var shouldShowErrorViewObservable: Observable<Bool> {
        return Observable.combineLatest(self.rx_items.asObservable(), self.rx_isLoading.asObservable(), self.rx_error.asObservable(), resultSelector: { (items, loading, error) -> Bool in
            return items.count == 0 && loading == false && error != nil
        })
    }
    
    public var shouldShowErrorPopupViewObservable: Observable<Bool> {
        return Observable.combineLatest(self.rx_items.asObservable(), self.rx_isLoading.asObservable(), self.rx_error.asObservable(), resultSelector: { (items, loading, error) -> Bool in
            return items.count != 0 && loading == false && error != nil
        })
    }
    
    public var shouldShowListViewObservable: Observable<Bool> {
        return self.rx_items.asObservable().map {$0.count > 0}
    }
    
    //MARK: NKPullingAction
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
    
    public func clearError() {
        self.rx_error.value = nil
    }
    
    public func doSomethingBeforeLoadingModels() -> Observable<Void>{
        return Observable.just(Void())
    }
    
    public func doSomethingAfterLoadLoadingModels(models: [Any]) -> Observable<[Any]> {
        return Observable.just(models)
    }
    
    private func resetModel() {
        var strongSelf = self
        strongSelf.rx_items.value = []
        strongSelf.rx_isLoadMore.value = true
        strongSelf.page = self.initPage
    }
    
    private func canLoadMore() -> Observable<Void> {
        return self.rx_isLoadMore.asObservable().take(1).filter {$0}.map { _ in return}
    }
    
    private func pullData() -> Observable<[Any]> {
        var strongSelf = self
        return strongSelf
            .canLoadMore()
            .debug("Can load more", trimOutput: true)
            .flatMapLatest({_ in strongSelf.doSomethingBeforeLoadingModels()})
            .debug("Did somthing before loading model, loading...", trimOutput: true)
            .flatMapLatest({_ in strongSelf.pull(page: strongSelf.page)})
            .debug("Pull successfully", trimOutput: true)
            .flatMapLatest({strongSelf.doSomethingAfterLoadLoadingModels(models: $0)})
            .debug("Did somthing after loading model", trimOutput: true)
            .do(onNext: {
                
                let value = strongSelf.map(value: $0)
                strongSelf.rx_isLoadMore.value = !(value.count == 0)
                strongSelf.rx_items.value += value
                strongSelf.page = strongSelf.page + 1
            })
        
    }
}

