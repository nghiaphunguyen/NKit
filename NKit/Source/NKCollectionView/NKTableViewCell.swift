//
//  NKTableViewCell.swift
//  NKit
//
//  Created by Apple on 6/30/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public class NKTableViewCell<T: UIView>: NKBaseTableViewCell, NKListViewCellConfigurable where T: NKListViewCellConfigurable {
    
    public typealias ViewCellModel = T.ViewCellModel
    public let cView: T = T()
    public override func setupView() {
        self.contentView.nk_addSubview(self.cView) {
            $0.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
        }
    }
    
    public func listView(_ listView: NKListView, configWithModel model: ViewCellModel, atIndexPath indexPath: IndexPath) {
        self.cView.listView(listView, configWithModel: model, atIndexPath: indexPath)
    }
    
    public static func size(with listView: NKListView, section: NKListSection, model: ViewCellModel) -> NKSize {
        return T.size(with: listView, section: section, model: model)
    }
    
    public func collectionView(_ collectionView: NKCollectionView, configWithModel model: ViewCellModel, atIndexPath indexPath: IndexPath) {
        self.cView.collectionView(collectionView, configWithModel: model, atIndexPath: indexPath)
    }
    
    public static func size(withCollectionView collectionView: NKCollectionView, section: NKCollectionSection, model: ViewCellModel) -> CGSize {
        return T.size(withCollectionView: collectionView, section: section, model: model)
    }
    
    public func tableView(_ tableView: NKTableView, configWithModel model: ViewCellModel, atIndexPath indexPath: IndexPath) {
        self.cView.tableView(tableView, configWithModel: model, atIndexPath: indexPath)
    }
    
    public static func height(withTableView tableView: NKTableView, section: NKTableSection, model: ViewCellModel) -> CGFloat {
        return T.height(withTableView: tableView, section: section, model: model)
    }
}
