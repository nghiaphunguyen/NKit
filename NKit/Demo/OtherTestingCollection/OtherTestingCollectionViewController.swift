//
//  OtherTestingCollectionViewController.swift
//  NKit
//
//  Created by Apple on 5/27/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import NRxSwift
import RxSwift

//MARK: Properties
final class OtherTestingCollectionViewController: UIViewController {
    fileprivate(set) var reactor: OtherTestingCollectionReactable? = nil
    
    fileprivate lazy var tableView : NKCollectionView = Id.tableView.view(self)
}

//MARK: Layout
extension OtherTestingCollectionViewController {
    fileprivate enum Id: String, NKViewIdentifier {
        case tableView
    }
    
    fileprivate struct Style {
        
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.nk_addSubview(NKCollectionView.init(sectionOptions: [[]]) ~ Id.tableView) {
            $0.backgroundColor = UIColor.green
            $0.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
//            $0.addSection(NKBaseTableSection.init(options: []))
            $0.register(cellType: NumberTableViewCell.self)
        }
    }
    
    func setupNavigationBar() {
        self.nk_setBarTintColor(UIColor.white).nk_setRightBarButton("LoadMore", selector: #selector(OtherTestingCollectionViewController.loadMore))
    }
    
    @objc func loadMore() {
        self.reactor?.action.loadMore()
    }
}

//MARK: React
fileprivate extension OtherTestingCollectionViewController {
    func setupState(withReactor reactor: OtherTestingCollectionReactable) {
        reactor.state.itemsObservable.nk_subscribe { [weak self] in
            self?.tableView.updateFirstSection(withModels: $0)
        }.addDisposableTo(self.nk_disposeBag)
    }
    
    func setupAction(withReactor reactor: OtherTestingCollectionReactable) {
        
    }
}

//MARK: Creator
extension OtherTestingCollectionViewController {
    static func testingInstance() -> OtherTestingCollectionViewController {
        return OtherTestingCollectionViewController()
    }
    
    static func instance() -> OtherTestingCollectionViewController {
        return OtherTestingCollectionViewController(reactor: OtherTestingCollectionReactor.instance())
    }
}

//MARK: Testing
extension OtherTestingCollectionViewController: NKLayoutTestable {}

extension OtherTestingCollectionViewController: NKLayoutModelable {
    typealias Model = Void
    
    func config(_ model: Model) {
    }
    
    static var models: [Model] {
        return []
    }
}

//MARK: Life cycle
extension OtherTestingCollectionViewController {
    convenience init(reactor: OtherTestingCollectionReactable) {
        self.init()
        
        self.reactor = reactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let reactor = self.reactor else {return}
        self.setupState(withReactor: reactor)
        self.setupAction(withReactor: reactor)
        
        reactor.action.loadMore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavigationBar()
    }
}
