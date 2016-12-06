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

public class NKPullingViewModelImp: NSObject, NKPullingViewModel {
    public let rx_items = Variable<[Any]>([])
    public let rx_error = Variable<Error?>(nil)
    public let rx_isLoading = Variable<Bool>(false)

    public var page: Int = 0
    public let initPage: Int = 0
    
    public func loadItems(page: Int) -> Observable<[Any]> {
        return Observable.empty()
    }
}

public protocol NKPullingViewModel: NKLoadable {
    var rx_items: Variable<[Any]> {get}
    
    var page: Int {get set}
    var initPage: Int {get}
    
    func loadMoreObservable() -> Observable<Void>
    mutating func refreshObservable() -> Observable<Void>
    
    func doSomethingBeforeLoadItemsObservable() -> Observable<Void>
    func doSomethingAfterLoadItemsObservable(items: [Any]) -> Observable<[Any]>
    
    func loadItems(page: Int) -> Observable<[Any]> // need override
}

public extension NKPullingViewModel where Self: AnyObject {
    private func updateItems(items: [Any]) {
        self.rx_items.value += items
        self.rx_items.nk_reload()
    }
    
    private mutating func resetPage(page: Int) {
        self.page = page
    }
    
    public func doSomethingBeforeLoadItemsObservable() -> Observable<Void> {
        return Observable.just(Void())
    }
    
    public func doSomethingAfterLoadItemsObservable(items: [Any]) -> Observable<[Any]> {
        return Observable.just(items)
    }
    
    public func loadMoreObservable() -> Observable<Void> {
        return self.load(self.doSomethingBeforeLoadItemsObservable()
            .flatMapLatest({_ in self.loadItems(page: self.page)})
            .flatMapLatest({self.doSomethingAfterLoadItemsObservable(items: $0)}))
            .do(onNext: {self.updateItems(items: $0)})
            .map {_ in return}
    }
    
    public mutating func refreshObservable() -> Observable<Void> {
        var page: Int = 0
        
        return self.load(Observable<Void>.nk_start {[unowned self] () -> Observable<Void> in
            var strongSelf = self
                page = self.page
                strongSelf.resetPage(page: self.initPage)
                return self.doSomethingBeforeLoadItemsObservable()
            }
            .flatMapLatest({[unowned self] _ in return self.loadItems(page: self.page)})
            .flatMapLatest({[unowned self] in self.doSomethingAfterLoadItemsObservable(items: $0)}))
            .do(onError: {[unowned self] _ in
                var strongSelf = self
                strongSelf.resetPage(page: page)
            }).map {_ in return}
    }
}

