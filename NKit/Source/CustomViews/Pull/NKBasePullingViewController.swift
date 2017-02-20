//
//  NKBasePullingViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/19/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import NRxSwift
import RxSwift

public protocol NKViewable {
    var view: UIView {get}
}

public extension NKViewable where Self: UIView {
    public var view: UIView { return self }
}

public protocol NKViewShowAndHidable: NKViewable {
    func show(payload: Any?, withCompletion completion: (() -> Void)?)
    func hide(withCompletion completion: (() -> Void)?)
}

public extension NKViewShowAndHidable where Self: UIView {
    public func show(payload: Any?, withCompletion completion: (() -> Void)?) {
        self.isHidden = false
        completion?()
    }
    
    public func hide(withCompletion completion: (() -> Void)?) {
        self.isHidden = true
        completion?()
    }
}

public protocol NKPullingRetryView: NKViewShowAndHidable {
    var tappedRetryButtonObservable: Observable<Void>? {get}
}

//MARK: Properties
open class NKBasePullingViewController: UIViewController {
    fileprivate(set) var pullingViewModel: NKPullingViewModelable? = nil
    
    public lazy var listView: NKListView = { self.getListView() }()
    public lazy var footerLoadingView: NKListSupplementaryViewConfigurable.Type = {return self.getFooterLoadingView() }()
    public lazy var loadingView: NKViewShowAndHidable = { return self.getLoadingView() }()
    public lazy var errorView: NKPullingRetryView = { return self.getErrorView() }()
    public lazy var popupErrorView: NKPullingRetryView = { return self.getPopupErrorView() }()
    public lazy var emptyView: NKPullingRetryView = { return self.getEmptyView() }()
    public lazy var refreshControl: UIRefreshControl = { return self.getRefreshControl() }()
    open var loadMoreOffset: CGFloat {return 20}
    
    open func getListView() -> NKListView {
        fatalError()
    }
    
    open func getFooterLoadingView() -> NKListSupplementaryViewConfigurable.Type { fatalError() }
    
    open func getLoadingView() -> NKViewShowAndHidable { fatalError() }
    
    open func getErrorView() -> NKPullingRetryView { fatalError()}
    
    open func getPopupErrorView() -> NKPullingRetryView { fatalError() }
    
    open func getEmptyView() -> NKPullingRetryView { fatalError() }
    
    open func getRefreshControl() -> UIRefreshControl { fatalError() }
}

//MARK: Layout
extension NKBasePullingViewController {
    
    override open func loadView() {
        super.loadView()
        
        self.view
            .nk_addSubview(self.emptyView.view) {
                $0.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
            }
            .nk_addSubview(self.errorView.view) {
                $0.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
            }.nk_addSubview(self.listView.view) {
                self.listView.updateFirstSection(withFooter: self.footerLoadingView)
                
                $0.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
                
                $0.nk_addSubview(self.refreshControl)
            }.nk_addSubview(self.popupErrorView.view) {
                $0.snp.makeConstraints({ (make) in
                    make.leading.trailing.top.equalToSuperview()
                })
            }.nk_addSubview(self.loadingView.view) {
                $0.snp.makeConstraints({ (make) in
                    make.center.equalToSuperview()
                })
        }
    }
}

//MARK: React
fileprivate extension NKBasePullingViewController {
    func setupViewModel(with viewModel: NKPullingViewModelable) {
        viewModel.shouldShowLoadingObseravble.subscribe(onNext: { [unowned self] in
            if $0 {
                if !self.refreshControl.isRefreshing {
                    self.loadingView.show(payload: nil, withCompletion: nil)
                }
            } else {
                self.loadingView.hide(withCompletion: nil)
                self.refreshControl.endRefreshing()
            }
        }).addDisposableTo(self.nk_disposeBag)
        
        viewModel.shouldShowEmptyViewObservable.subscribe(onNext: { [unowned self] in
            $0 ? self.emptyView.show(payload: nil, withCompletion: nil) : self.emptyView.hide(withCompletion: nil)
        }).addDisposableTo(self.nk_disposeBag)
        
        viewModel.shouldShowErrorViewObservable.subscribe(onNext: { [unowned self] in
            $0 ? self.errorView.show(payload: viewModel.errorString.value, withCompletion: nil) : self.errorView.hide(withCompletion: nil)
        }).addDisposableTo(self.nk_disposeBag)
        
        viewModel.shouldShowErrorPopupViewObservable.subscribe(onNext: { [unowned self] in
            $0 ? self.popupErrorView.show(payload: viewModel.errorString.value, withCompletion: nil) : self.popupErrorView.hide(withCompletion: nil)
        }).addDisposableTo(self.nk_disposeBag)
        
        viewModel.items.observable.subscribe(onNext: { [unowned self] in
            self.listView.updateFirstSection(withModels: $0)
        }).addDisposableTo(self.nk_disposeBag)
        
        viewModel.isLoadMore.observable.subscribe(onNext: { [unowned self] in
            self.listView.updateFirstSection(withFooterModel: $0)
        }).addDisposableTo(self.nk_disposeBag)
        
        viewModel.shouldShowListViewObservable.map{!$0}.bindTo(self.listView.view.rx.isHidden).addDisposableTo(self.nk_disposeBag)
        //Actions
        self.refreshControl.rx.controlEvent(UIControlEvents.valueChanged).throttle(1, scheduler: MainScheduler.instance).bindNext {
            viewModel.refresh()
        }.addDisposableTo(self.nk_disposeBag)
        
        let listView = self.listView.view
        let loadMoreOffset = self.loadMoreOffset
        listView.rx.contentOffset.filter { contentOffset in
            return listView.nk_height <= listView.contentSize.height && contentOffset.y >= listView.contentSize.height - listView.nk_height + loadMoreOffset}.throttle(1, scheduler: MainScheduler.instance).subscribe(onNext: {_ in
            viewModel.loadMore()
        }).addDisposableTo(self.nk_disposeBag)
        
        self.popupErrorView.tappedRetryButtonObservable?.subscribe(onNext: { [unowned self] in
            self.popupErrorView.hide(withCompletion: {
                viewModel.loadMore()
            })
        }).addDisposableTo(self.nk_disposeBag)
        
        self.errorView.tappedRetryButtonObservable?.subscribe(onNext: { [unowned self] in
            self.errorView.hide(withCompletion: {
                viewModel.refresh()
            })
        }).addDisposableTo(self.nk_disposeBag)
        
        self.emptyView.tappedRetryButtonObservable?.subscribe(onNext: { [unowned self] in
            self.emptyView.hide(withCompletion: {
                viewModel.refresh()
            })
        }).addDisposableTo(self.nk_disposeBag)
    }
}


//MARK: Life cycle
extension NKBasePullingViewController {
    public convenience init(pullingViewModel: NKPullingViewModelable) {
        self.init()
        
        self.pullingViewModel = pullingViewModel
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = self.pullingViewModel else {return}
        self.setupViewModel(with: viewModel)
        
        viewModel.refresh()
    }
}
