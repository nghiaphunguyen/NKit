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
    associatedtype CollectionViewItemModel
    func collectionView(collectionView: NKCollectionView, configWithModel model: CollectionViewItemModel, atIndexPath indexPath: NSIndexPath)
}

public class NKCollectionView: UICollectionView {
    private lazy var preHeight: CGFloat? = nil
    
    public var isHeightToFit = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public lazy var animateFitHeightDuration: NSTimeInterval = 0
    
    public weak var nk_dataSource: NKCollectionViewDataSource? {
        didSet {
            self.dataSource = self
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.isHeightToFit && self.contentSize.height != self.preHeight{
            self.preHeight = self.contentSize.height
            
            self.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(self.contentSize.height)
            })
            
            UIView.animateWithDuration(self.animateFitHeightDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.layoutIfNeeded()
                }, completion: nil)
        }
        
    }
    
    public var nk_viewForSupplementaryElementClosure: ((collectionView: UICollectionView, kind: String, indexPath: NSIndexPath) -> UICollectionReusableView)? = nil
    
    public var nk_animateForCellClosure: ((cell: UICollectionViewCell, indexPath: NSIndexPath) -> Void)? = nil
    
    public var nk_moreConfigForCellClosure: ((cell: UICollectionViewCell, indexPath: NSIndexPath) -> Void)? = nil
    
    private typealias ConfigViewBlock = (cell: UIView, model: Any, indexPath: NSIndexPath) -> Void
    
    private lazy var modelViewTypeMapping = [String: (viewType: UIView.Type, configViewBlock: ConfigViewBlock)]()
}

public extension NKCollectionView {
    public func registerView<T: UICollectionViewCell where T: NKCollectionViewItemProtocol>(type: T.Type) {
        let modelName = "\(type.CollectionViewItemModel.self)"
        
        self.registerClass(T.self, forCellWithReuseIdentifier: modelName)
        self.modelViewTypeMapping[modelName] = (viewType: type, configViewBlock: {[weak self] (view, model, indexPath) in
            guard let strongSelf = self else {
                return
            }
            
            if let view = view as? T, model = model as? T.CollectionViewItemModel {
                view.collectionView(strongSelf, configWithModel: model, atIndexPath: indexPath)
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
        mapping.configViewBlock(cell: cell, model: items[section][row], indexPath: indexPath)
        
        self.nk_animateForCellClosure?(cell: cell, indexPath: indexPath)
        self.nk_moreConfigForCellClosure?(cell: cell, indexPath: indexPath)
        return cell
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.nk_dataSource?.itemsForCollectionView(self).count ?? 0
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let closure = self.nk_viewForSupplementaryElementClosure else {
            return UICollectionReusableView()
        }
        
        return closure(collectionView: collectionView, kind: kind, indexPath: indexPath)
    }
}
