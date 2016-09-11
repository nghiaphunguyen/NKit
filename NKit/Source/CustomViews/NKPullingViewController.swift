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
    func loadMore() {
        self.model.loadMore().subscribe().addDisposableTo(self.nk_disposeBag)
    }
    
    func refresh() {
        self.model.refresh().subscribe().addDisposableTo(self.nk_disposeBag)
    }
}

public protocol NKPullingViewModel {
    var rx_items: Variable<[Any]> {get set}
    var rx_isLoading: Variable<Bool> {get}
    var rx_error: Variable<ErrorType> {get}
    
    var page: Int {get set}
    
    func loadMore() -> Observable<Void>
    func refresh() -> Observable<Void>
    
    func doSomethingBeforeLoadItems() -> Observable<Void>
    func doSomthingAfterLoadItems(items: [Any]) -> Observable<[Any]>
    
    func resetPage() // need override
    func loadItems(page page: Int) -> Observable<[Any]> // need override
}

public extension NKPullingViewModel {
    private func updateItems(items: [Any]) {
        self.rx_items.value += items
        self.rx_items.nk_reload()
    }
    
    private func resetAfterDone() {
        self.rx_isLoading.value = false
    }
    
    private func setupBeforeLoading() {
        self.rx_isLoading.value = true
    }
    
    private var canLoadData: Observable<Void> {
        return self.rx_isLoading.asObservable()
            .filter({$0 == false})
            .map {_ in return}
    }
    
    func doSomethingBeforeLoadItems() -> Observable<Void> {
        return Observable.just()
    }
    
    func doSomethingAfterLoadItems(items: [Any]) -> Observable<[Any]> {
        return Observable.just(items)
    }
    
    func loadMore() -> Observable<Void> {
        return self.canLoadData
            .flatMapLatest({_ in return self.doSomethingBeforeLoadItems()})
            .flatMapLatest({_ in self.loadItems(page: self.page)})
            .flatMapLatest({self.doSomthingAfterLoadItems($0)})
            .doOnNext({ self.updateItems($0)})
            .doOnError({self.rx_error.value = $0})
            .nk_doOnNextOrError({_ in self.resetAfterDone()})
            .map {_ in return}
    }
    
    mutating func refresh() -> Observable<Void> {
        var page: Int = 0
        return self.canLoadData
            .flatMapLatest({_ in return Observable.nk_start({ () -> Observable<Void> in
            page = self.page
            self.resetPage()
            return self.doSomethingBeforeLoadItems()
        })}).flatMapLatest({_ in return self.loadItems(page: self.page)})
            .flatMapLatest({self.doSomthingAfterLoadItems($0)})
            .doOnNext({ self.rx_items.value = $0})
            .doOnError({_ in self.page = page})
            .doOnError({self.rx_error.value = $0})
            .nk_doOnNextOrError({_ in self.resetAfterDone()})
            .map {_ in return}
    }
}

