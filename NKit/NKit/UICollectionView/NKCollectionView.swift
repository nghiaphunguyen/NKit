//
//  NKCollectionView.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 5/16/16.
//  Copyright © 2016 misfit. All rights reserved.
//

import UIKit

public protocol NKCollectionViewDataSource: class {
    func itemsForCollectionView(collectionView: NKCollectionView) -> [[Any]]
}

public protocol NKCollectionViewItemProtocol: class {
    typealias CollectionViewItemModel
    func collectionView(collectionView: NKCollectionView, configWithModel model: CollectionViewItemModel)
}

public class NKCollectionView: UICollectionView {
    public weak var nk_dataSource: NKCollectionViewDataSource? {
        didSet {
            self.dataSource = self
        }
    }
    
    public var nk_viewForSupplementaryElementClosure: ((kind: String, indexPath: NSIndexPath) -> UICollectionReusableView)?
    
    private typealias ConfigViewBlock = (cell: UIView, model: Any) -> Void
    
    private lazy var modelViewTypeMapping = [String: (viewType: UIView.Type, configViewBlock: ConfigViewBlock)]()
}

public extension NKCollectionView {
    public func registerView<T: UICollectionViewCell where T: NKCollectionViewItemProtocol>(type: T.Type) {
        let modelName = "\(type.CollectionViewItemModel.self)"
        
        self.registerClass(T.self, forCellWithReuseIdentifier: modelName)
        self.modelViewTypeMapping[modelName] = (viewType: type, configViewBlock: {[weak self] (view, model) in
            guard let strongSelf = self else {
                return
            }
            
            if let view = view as? T, model = model as? T.CollectionViewItemModel {
                view.collectionView(strongSelf, configWithModel: model)
            }
            })
    }
}

extension NKCollectionView: UICollectionViewDataSource {
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = self.nk_dataSource?.itemsForCollectionView(self) where items.count > section else {
            return 0
        }
        
        return items[section].count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        guard let items = self.nk_dataSource?.itemsForCollectionView(self) where items.count > section && items[section].count > row else {
            return UICollectionViewCell()
        }
        
        let typeName = "\(items[section][row].dynamicType.self)"
        guard let mapping = self.modelViewTypeMapping[typeName] else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(typeName, forIndexPath: indexPath)
        mapping.configViewBlock(cell: cell, model: items[section][row])
        return cell
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.nk_dataSource?.itemsForCollectionView(self).count ?? 0
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let closure = self.nk_viewForSupplementaryElementClosure else {
            return UICollectionReusableView()
        }
        
        return closure(kind: kind, indexPath: indexPath)
    }
}