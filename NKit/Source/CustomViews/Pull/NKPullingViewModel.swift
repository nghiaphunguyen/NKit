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

public enum ResetType {
    case clear
    case `default`
}

public protocol NKPullingViewModelable: NKLoadable, NKPullingState, NKPullingAction {
    //MARK: need override
    
    var rx_items: Variable<[Any]> {get}
    var viewModelsObservable: Observable<[NKDiffable]> {get}
    var rx_isLoadMore: Variable<Bool> {get}
    var page: Int {get set}
    var initPage: Int {get}
    var offset: Int {get set}
    var limit: Int {get}
    var resetType: ResetType {get}
    
    // pull items from ouside source
    func pull() -> Observable<[Any]>
    
    // Mapping from pulling items to view model items
    func map(value: Any) -> NKDiffable?
    
    //MARK: Optional
    func doSomethingBeforeLoadingModels() -> Observable<Void>
    func doSomethingAfterLoadLoadingModels(models: [Any]) -> Observable<[Any]>
    func resetModel()
    func reverseModel() -> () -> Void
}

public extension NKPullingViewModelable where Self: NSObject {
    
    //MARK: NKPullingState
    public var resetType: ResetType {
        return .default
    }
    
    public var viewModelsObservable: Observable<[NKDiffable]> {
        return self.rx_items.asObservable().map {$0.flatMap {[unowned self] in self.map(value: $0)}}
    }
    
    public var items: NKVariable<[Any]> {
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
        strongSelf.load(self.pullData().do(onNext: { [unowned strongSelf] in
            strongSelf.rx_items.value += $0
            strongSelf.rx_isLoadMore.value = !($0.count == 0)
            }
            
        ))
            .subscribe()
            .addDisposableTo(self.nk_disposeBag)
    }
    
    public func refresh() {
        let strongSelf = self
        let reverseModelClosure = self.reverseModel()
        let observable: Observable<Void> = self.resetType == .clear ? Observable<Void>.nk_from(strongSelf.resetModel).flatMapLatest({[unowned strongSelf] in Observable<Void>.nk_from(strongSelf.resetItems)}) : Observable<Void>.nk_from(strongSelf.resetModel)
        strongSelf.load(
                observable
                .flatMapLatest({[unowned strongSelf] _ in strongSelf.pullData().do(onNext: {
                    strongSelf.rx_items.value = $0
                    strongSelf.rx_isLoadMore.value = !($0.count == 0)
                }, onError: {[unowned strongSelf] _ in
                    if strongSelf.resetType == .default {
                        reverseModelClosure()
                    }
                })})
            )
            .subscribe()
            .addDisposableTo(self.nk_disposeBag)
    }
    
    public func clearError() {
        if self.rx_error.value != nil {
            self.rx_error.value = nil
        }
    }
    
    public func doSomethingBeforeLoadingModels() -> Observable<Void>{
        return Observable.just(Void())
    }
    
    public func doSomethingAfterLoadLoadingModels(models: [Any]) -> Observable<[Any]> {
        return Observable.just(models)
    }
    
    public func resetModel() {
        var strongSelf = self
        strongSelf.rx_isLoadMore.value = true
        strongSelf.page = self.initPage
        strongSelf.offset = 0
    }
    
    public func reverseModel() -> () -> Void {
        let isLoadMore = self.rx_isLoadMore.value
        let page = self.page
        let offset = self.offset
        
        return { [weak self] in
            guard var sSelf = self else {
                return
            }
            sSelf.rx_isLoadMore.value = isLoadMore
            sSelf.page = page
            sSelf.offset = offset
        }
    }
    
    public func resetItems() {
        self.rx_items.value = []
    }
    
    private func pullData() -> Observable<[Any]> {
        let strongSelf = self
        return Observable.nk_start({ [unowned strongSelf] in
            if self.rx_isLoadMore.value == true {
                return strongSelf.doSomethingBeforeLoadingModels()
                    .flatMapLatest({[unowned strongSelf] _ in strongSelf.pull()})
                    .do(onNext: { [weak strongSelf] in
                        guard var sSelf = strongSelf else {return}
                        
                        sSelf.page = sSelf.page + 1
                        sSelf.offset += $0.count
                        sSelf.rx_isLoadMore.value = !($0.count == 0)
                    })
                    .flatMapLatest({[unowned strongSelf] in strongSelf.doSomethingAfterLoadLoadingModels(models: $0)})
            } else {
                return Observable.just([])
            }
        })
    }
}

