//
//  NKCollectionView.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 5/16/16.
//  Copyright © 2016 misfit. All rights reserved.
//

import UIKit
import RxSwift

public protocol NKCollectionViewDataSource: class {
    func itemsForCollectionView(collectionView: NKCollectionView) -> [[Any]]
}

public protocol NKCollectionViewItemProtocol: class {
    associatedtype CollectionViewItemModel
    func collectionView(collectionView: NKCollectionView, configWithModel model: CollectionViewItemModel, atIndexPath indexPath: NSIndexPath)
}

public class NKCollectionView: UICollectionView {
    public enum Option {
        case LineSpace(CGFloat)
        case InterItemSpacing(CGFloat)
        case ItemSize(CGSize)
        case ScrollDirection(UICollectionViewScrollDirection)
        case SectionInset(UIEdgeInsets)
        case AutoFitCell(CGSize, NKDimension)
    }
    
    private lazy var preHeight: CGFloat? = nil
    
    public convenience init(options: [Option]) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsZero
        var dimension: NKDimension? = nil
        for option in options {
            switch option {
            case .LineSpace(let value):
                flowLayout.minimumLineSpacing = value
            case .InterItemSpacing(let value):
                flowLayout.minimumInteritemSpacing = value
            case .ItemSize(let value):
                flowLayout.itemSize = value
            case .ScrollDirection(let value):
                flowLayout.scrollDirection = value
            case .SectionInset(let value):
                flowLayout.sectionInset = value
            case .AutoFitCell(let size, let value):
                flowLayout.estimatedItemSize = size
                dimension = value
            }
        }
        
        self.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.autoFitCellDimension = dimension
    }
    
    public var isHeightToFit = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var autoFitCellDimension: NKDimension? = nil {
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
    
    private lazy var rx_paging = Variable<Bool?>(nil)
    public var nk_paging: Bool {
        get {
            return self.rx_paging.value ?? false
        }
        
        set {
            self.rx_paging.value = newValue
            
            if newValue {
                self.setupPaging()
            }
        }
    }
    
    private func setupPaging() {
        var startedOffset: CGPoint? = nil
        
        self.nk_scrollViewWillBeginDraggingObservable
            .takeUntil(self.rx_paging.asObservable().filter({$0 == false}))
            .subscribeNext { (point) in
                startedOffset = point
            }.addDisposableTo(self.nk_disposeBag)
        
        self.nk_scrollViewWillEndScrollingObservable
            .takeUntil(self.rx_paging.asObservable().filter({$0 == false}))
            .bindNext { (point) in
                guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
                    return
                }
                
                let isHorizontal = layout.scrollDirection == .Horizontal
                
                let value = ((isHorizontal) ? layout.itemSize.width : layout.itemSize.height) + layout.minimumLineSpacing
                
                let firstCenter = isHorizontal ? layout.sectionInset.left + layout.itemSize.width / 2 : layout.sectionInset.top + layout.itemSize.height / 2
                let xFirstCenter = isHorizontal ? self.nk_width / 2 : self.nk_height / 2
                let firstValue = value - (xFirstCenter - firstCenter)
                
                let sOffset = isHorizontal ? startedOffset?.x : startedOffset?.y
                let offset = isHorizontal ? point.x : point.y
                let minOffset: CGFloat = 0
                
                let maxOffset = isHorizontal ? self.contentSize.width - self.nk_width : self.contentSize.height - self.nk_height
                
                let currentPage: Int
                if offset >= firstValue {
                    currentPage = Int((offset - firstValue) / value) + 1
                } else {
                    currentPage = 0
                }
                
                let k = offset > sOffset ? 1 : 0
                
                let page = currentPage + k
                
                let newOffset = max(minOffset, min(CGFloat(page - 1) * value + (page > 0 ? firstValue : 0), maxOffset))
                let newPoint = isHorizontal ? CGPointMake(newOffset, point.y) : CGPointMake(point.x, newOffset)
                self.setContentOffset(newPoint, animated: true)
            }.addDisposableTo(self.nk_disposeBag)
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
        if let cell = cell as? NKBaseCollectionViewCell {
            cell.autoFitDimension = self.autoFitCellDimension
        }
        
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
