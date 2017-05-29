//
//  NKBasePullingViewModel.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/19/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import NRxSwift

open class NKBasePullingViewModel: NSObject, NKPullingViewModelable {

    public var rx_items = Variable<[Any]>([])
    public var rx_isLoadMore = Variable<Bool>(true)
    public var rx_isLoading = Variable<Bool>(false)
    public var rx_error = Variable<Error?>(nil)
    public var requestDisposable: Disposable? = nil
    public lazy var page: Int = {return self.getInitPage()}()
    public lazy var initPage: Int = {return self.getInitPage()}()
    public lazy var limit: Int = {return self.getLimit()}()
    public lazy var offset: Int = {return self.getOffset()}()
    public lazy var resetType: ResetType = {return self.getResetType()}()
    
    open var viewModelsObservable: Observable<[NKDiffable]> {
        return self.rx_items.asObservable().map { $0.flatMap {[unowned self] in self.map(value: $0)} }
    }
    
    open var errorString: NKVariable<String?> {
        return self.rx_error.nk_variable.map({ $0.map {self.errorString(error: $0)} })
    }
    
    open func resetModel() {
        let strongSelf = self
        strongSelf.rx_isLoadMore.value = true
        strongSelf.page = self.initPage
        strongSelf.offset = 0
    }
    
    open func reverseModel() -> () -> Void {
        let isLoadMore = self.rx_isLoadMore.value
        let page = self.page
        let offset = self.offset
        
        return { [weak self] in
            guard let sSelf = self else {
                return
            }
            sSelf.rx_isLoadMore.value = isLoadMore
            sSelf.page = page
            sSelf.offset = offset
        }
    }
    
    open func getOffset() -> Int {
        return 0
    }
    
    open func getResetType() -> ResetType {
        return .default
    }
    
    open func getInitPage() -> Int {
        fatalError()
    }
    
    open func getLimit() -> Int {
        fatalError()
    }
    
    open func pull() -> Observable<[Any]> {
        fatalError()
    }
    
    open func map(value: Any) -> NKDiffable? {
        fatalError()
    }
    
    open func errorString(error: Error) -> String {
        fatalError()
    }
}
