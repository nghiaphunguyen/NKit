//
//  NKListSupplementaryViewConfigurable.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/10/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKListSupplementaryViewConfigurable: class, NKIdentifier {
    
    func listView(_ listView: NKListView, configWithModel model: Any, at section: Int)
    
    static func size(with listView: NKListView, section: NKListSection, model: Any?) -> NKSize
    
    func collectionView(_ collectionView: NKCollectionView, configWithModel model: Any, at section: Int)
    
    static func size(withColletionView collectionView: NKCollectionView, section: NKCollectionSection, model: Any?) -> CGSize
    
    func tableView(_ tableView: NKTableView, configWithModel model: Any, at section: Int)
    
    static func height(withTableView tableView: NKTableView, section: NKTableSection, model: Any?) -> CFloat
}

extension NKListSupplementaryViewConfigurable where Self: UICollectionReusableView {
    public func listView(_ listView: NKListView, configWithModel model: Any, at section: Int) {
        guard let collectionView = listView as? NKCollectionView else {
            return
        }
        
        return self.collectionView(collectionView, configWithModel: model, at: section)
    }
    
    public static func size(with listView: NKListView, section: NKListSection, model: Any?) -> NKSize {
        guard let collectionView = listView as? NKCollectionView, let section = section as? NKCollectionSection else { return CGSize.zero}
        
        return self.size(withColletionView: collectionView, section: section, model: model)
    }
    
    public func tableView(_ tableView: NKTableView, configWithModel model: Any, at section: Int) {
    }
    
    public static func height(withTableView tableView: NKTableView, section: NKTableSection, model: Any?) -> CFloat {
        return 0
    }
}

extension NKListSupplementaryViewConfigurable where Self: UITableViewHeaderFooterView {
    public func listView(_ listView: NKListView, configWithModel model: Any, at section: Int) {
        guard let tableView = listView as? NKTableView else {
            return
        }
        
        return self.tableView(tableView, configWithModel: model, at: section)
    }
    
    public static func size(with listView: NKListView, section: NKListSection, model: Any?) -> NKSize {
        guard let tableView = listView as? NKTableView, let section = section as? NKTableSection else { return CGFloat(0)}
//        return (0 as CGFloat)
        let result = self.height(withTableView: tableView, section: section, model: model)
        
        return result as! NKSize
    }
    
    public func collectionView(_ collectionView: NKCollectionView, configWithModel model: Any, at section: Int) {
    }
    
    public static func size(withColletionView: NKCollectionView, section: NKCollectionSection, model: Any?) -> CGSize {
        return .zero
    }
}
