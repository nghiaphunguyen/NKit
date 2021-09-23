//
//  PullingTestingViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/19/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift

class TextCell: NKBaseTableViewCell, NKListViewCellConfigurable {
    typealias ViewCellModel = String
    lazy var label = UILabel()
    
    override func setupView() {
        self.contentView.nk_addSubview(self.label) {
            $0.sizeToFit()
            $0.numberOfLines = 0
            $0.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
        }
    }
    
    func tableView(_ tableView: NKTableView, configWithModel model: ViewCellModel, atIndexPath indexPath: IndexPath) {
        self.label.text = model
    }
    
    static func height(withTableView tableView: NKTableView, section: NKTableSection, model: ViewCellModel) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: Properties
final class PullingTestingViewController: DemoPullingViewController {
    fileprivate var reactor: PullingTestingReactable? {
        return self.pullingViewModel as? PullingTestingReactable
    }
    
    override func getListView() -> NKListView {
        let view = NKTableView(frame: .zero, style: .grouped)
        view.register(cellType: TextCell.self)
        view.separatorStyle = .none
        view.estimatedRowHeight = NKTableViewAutomaticHeight
        view.addSection(NKBaseTableSection.init(options: []))
        return view
    }
}

//MARK: Layout
extension PullingTestingViewController {
    override func loadView() {
        super.loadView()
        
        self.view.nk_config {
            $0.backgroundColor = UIColor.white
        }
    }
    func setupNavigationBar() {
        self.nk_setBarTintColor(UIColor.white)
    }
}

//MARK: React
fileprivate extension PullingTestingViewController {
    func setupState(with reactor: PullingTestingReactable) {
        
    }
    
    func setupAction(with reactor: PullingTestingReactable) {
        
    }
}

//MARK: Testing
extension PullingTestingViewController: NKLayoutTestable {}

extension PullingTestingViewController: NKLayoutModelable {
    typealias Model = Void
    
    func config(_ model: Model) {
    }
    
    static var models: [Model] {
        return []
    }
}

//MARK: Life cycle
extension PullingTestingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let reactor = self.reactor else {return}
        self.setupState(with: reactor)
        self.setupAction(with: reactor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavigationBar()
    }
}
