//
//  PullingViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/11/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift

public protocol NKPullingViewControllerProtocol {
    associatedtype ViewModel: NKPullingViewModel
    
    var model: ViewModel {get}
    var collectionView: NKCollectionView {get}
    var loadingView: UIView {get}
    var errorView: UIView {get}
    
    func loadMore()
    func refresh()
}

public extension NKPullingViewControllerProtocol where Self: UIViewController {
    public func loadMore() {
        self.model.loadMoreObservable().subscribe().addDisposableTo(self.nk_disposeBag)
    }
    
    public func refresh() {
        var model = self.model
        model.refreshObservable().subscribe().addDisposableTo(self.nk_disposeBag)
    }
}

public protocol NKPullingViewModel: NKLoadable {
    var rx_items: Variable<[Any]> {get set}
    
    var page: Int {get set}
    
    func loadMoreObservable() -> Observable<Void>
    mutating func refreshObservable() -> Observable<Void>
    
    func doSomethingBeforeLoadItemsObservable() -> Observable<Void>
    func doSomethingAfterLoadItemsObservable(items: [Any]) -> Observable<[Any]>
    
    func resetPage() // need override
    func loadItems(page page: Int) -> Observable<[Any]> // need override
}

public extension NKPullingViewModel {
    private func updateItems(items: [Any]) {
        self.rx_items.value += items
        self.rx_items.nk_reload()
    }
    
    public func doSomethingBeforeLoadItemsObservable() -> Observable<Void> {
        return Observable.just()
    }
    
    public func doSomethingAfterLoadItemsObservable(items: [Any]) -> Observable<[Any]> {
        return Observable.just(items)
    }
    
    public func loadMoreObservable() -> Observable<Void> {
        return self.load(self.doSomethingBeforeLoadItemsObservable()
            .flatMapLatest({_ in self.loadItems(page: self.page)})
            .flatMapLatest({self.doSomethingAfterLoadItemsObservable($0)}))
            .doOnNext({self.updateItems($0)})
            .map {_ in return}
    }
    
    public mutating func refreshObservable() -> Observable<Void> {
        var page: Int = 0
        
        return self.load(Observable<Void>.nk_start { () -> Observable<Void> in
                page = self.page
                self.resetPage()
                return self.doSomethingBeforeLoadItemsObservable()
            }
            .flatMapLatest({_ in return self.loadItems(page: self.page)})
            .flatMapLatest({self.doSomethingAfterLoadItemsObservable($0)}))
            .doOnError({_ in self.page = page}).map {_ in return}
    }
}

