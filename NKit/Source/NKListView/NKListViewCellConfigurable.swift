//
//  NKListViewCellConfigurable.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/10/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKListViewCellConfigurable: NKIdentifier {
    associatedtype ViewCellModel
    
    func listView(_ listView: NKListView, configWithModel model: ViewCellModel, atIndexPath indexPath: IndexPath)
    
    static func size(with listView: NKListView, section: NKListSection, model: ViewCellModel) -> NKSize
    
    func collectionView(_ collectionView: NKCollectionView, configWithModel model: ViewCellModel, atIndexPath indexPath: IndexPath)
    
    static func size(withCollectionView collectionView: NKCollectionView, section: NKCollectionSection, model: ViewCellModel) -> CGSize
    
    func tableView(_ tableView: NKTableView, configWithModel model: ViewCellModel, atIndexPath indexPath: IndexPath)
    
    static func height(withTableView tableView: NKTableView, section: NKTableSection, model: ViewCellModel) -> CGFloat
}

public extension NKListViewCellConfigurable where Self: UICollectionViewCell {
    public func listView(_ listView: NKListView, configWithModel model: ViewCellModel, atIndexPath indexPath: IndexPath) {
        guard let collectionView = listView as? NKCollectionView else {return}
        
        return self.collectionView(collectionView, configWithModel: model, atIndexPath: indexPath)
    }
    
    public static func size(with listView: NKListView, section: NKListSection, model: ViewCellModel) -> NKSize {
        
        guard let collectionView = listView as? NKCollectionView, let section = section as? NKCollectionSection else { return CGSize.zero }
        
        return self.size(withCollectionView: collectionView, section: section, model: model)
    }
    
    public func tableView(_ tableView: NKTableView, configWithModel model: ViewCellModel, atIndexPath indexPath: IndexPath) {
    }
    
    public static func height(withTableView tableView: NKTableView, section: NKTableSection, model: ViewCellModel) -> CGFloat {
        return 0
    }
}


public extension NKListViewCellConfigurable where Self: UITableViewCell {
    public func listView(_ listView: NKListView, configWithModel model: ViewCellModel, atIndexPath indexPath: IndexPath) {
        guard let tableView = listView as? NKTableView else {return}
        return self.tableView(tableView, configWithModel: model, atIndexPath: indexPath)
    }
    
    public static func size(with listView: NKListView, section: NKListSection, model: ViewCellModel) -> NKSize {
        guard let tableView = listView as? NKTableView, let section = section as? NKTableSection else {return CGFloat(0)}
        return self.height(withTableView: tableView, section: section, model: model)
    }
    
    public func collectionView(_ collectionView: NKCollectionView, configWithModel model: ViewCellModel, atIndexPath indexPath: IndexPath) {
    }
    
    public static func size(withCollectionView collectionView: NKCollectionView, section: NKCollectionSection, model: ViewCellModel) -> CGSize {
        return .zero
    }
}
