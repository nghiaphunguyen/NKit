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
    func collectionView(collectionView: NKCollectionView, configWithModel model: CollectionViewItemModel, atIndexPath indexPath: IndexPath)
}

open class NKCollectionView: UICollectionView {
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
        flowLayout.sectionInset = UIEdgeInsets.zero
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
    
    open var isHeightToFit = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open var autoFitCellDimension: NKDimension? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open lazy var animateFitHeightDuration: TimeInterval = 0
    
    open weak var nk_dataSource: NKCollectionViewDataSource? {
        didSet {
            self.dataSource = self
        }
    }
    
    private lazy var rx_paging = Variable<Bool?>(nil)
    open var nk_paging: Bool {
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
            .subscribe(onNext: { (point) in
                startedOffset = point
            }).addDisposableTo(self.nk_disposeBag)
        
        self.nk_scrollViewWillEndScrollingObservable
            .takeUntil(self.rx_paging.asObservable().filter({$0 == false}))
            .bindNext { (point) in
                guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
                    return
                }
                
                let isHorizontal = layout.scrollDirection == .horizontal
                
                let value = ((isHorizontal) ? layout.itemSize.width : layout.itemSize.height) + layout.minimumLineSpacing
                
                let firstCenter = isHorizontal ? layout.sectionInset.left + layout.itemSize.width / 2 : layout.sectionInset.top + layout.itemSize.height / 2
                let xFirstCenter = isHorizontal ? self.nk_width / 2 : self.nk_height / 2
                let firstValue = value - (xFirstCenter - firstCenter)
                
                let sOffset = (isHorizontal ? startedOffset?.x : startedOffset?.y) ?? 0
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
                let newPoint = isHorizontal ? CGPoint(x: newOffset, y: point.y) : CGPoint(x: point.x, y: newOffset)
                self.setContentOffset(newPoint, animated: true)
            }.addDisposableTo(self.nk_disposeBag)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.isHeightToFit && self.contentSize.height != self.preHeight{
            self.preHeight = self.contentSize.height
            
            self.snp.updateConstraints({ (make) -> Void in
                make.height.equalTo(self.contentSize.height)
            })
            
            UIView.animate(withDuration: self.animateFitHeightDuration, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.layoutIfNeeded()
                }, completion: nil)
        }
        
    }
    
    open var nk_viewForSupplementaryElementClosure: ((_ collectionView: UICollectionView, _ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView)? = nil
    
    open var nk_animateForCellClosure: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)? = nil
    
    open var nk_moreConfigForCellClosure: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)? = nil
    
    lazy var modelViewCellConfigs = [NKCollectionViewCellConfigurable]()
}

public extension NKCollectionView {
    public func registerView<T: UICollectionViewCell>(_ type: T.Type) where T: NKCollectionViewItemProtocol {
        let modelName = "\(type.CollectionViewItemModel.self)"
        
        self.register(T.self, forCellWithReuseIdentifier: modelName)
        
        self.modelViewCellConfigs.append(NKCollectionViewCellConfigure<T>(reuseIdentifier: modelName))
    }
}

extension NKCollectionView: UICollectionViewDataSource {
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = self.nk_dataSource?.itemsForCollectionView(collectionView: self) , items.count > section else {
            return 0
        }
        
        return items[section].count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        guard let items = self.nk_dataSource?.itemsForCollectionView(collectionView: self) , items.count > section && items[section].count > row else {
            return UICollectionViewCell()
        }
        
        let model = items[section][row]
        guard let mapping = (self.modelViewCellConfigs.nk_firstMap({$0.isMe(model: model)})) else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mapping.reuseIdentifier, for: indexPath)
        if let cell = cell as? NKBaseCollectionViewCell {
            cell.autoFitDimension = self.autoFitCellDimension
        }
        
        mapping.config(collectionView: self, cell: cell, model: model, indexPath: indexPath)
        
        self.nk_animateForCellClosure?(cell, indexPath)
        self.nk_moreConfigForCellClosure?(cell, indexPath)
        return cell
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.nk_dataSource?.itemsForCollectionView(collectionView: self).count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let closure = self.nk_viewForSupplementaryElementClosure else {
            return UICollectionReusableView()
        }
        
        return closure(collectionView, kind, indexPath)
    }
}
