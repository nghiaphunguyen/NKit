//
//  NKCollectionSection.swift
//  IgListKitExample
//
//  Created by Nghia Nguyen on 1/24/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import Foundation
import UIKit

public protocol NKDiffable {
    var diffIdentifier: String {get}
}

open class NKCollectionSection: NSObject {
    fileprivate(set) var models: [NKDiffable] = []
    fileprivate(set) var headerModel: Any? = nil
    fileprivate(set) var footerModel: Any? = nil
    
    var headerConfiguarationType: NKCollectionSupplementaryViewConfigurable.Type? = nil
    
    var footerConfiguarationType: NKCollectionSupplementaryViewConfigurable.Type? = nil
    
    open func inset(with collectionView: UICollectionView) -> UIEdgeInsets {
        return .zero
    }
    
    open func minimumLineSpacing(with collectionView: UICollectionView) -> CGFloat {
        return 0
    }
    
    open func minimumInteritemSpacing(with collectionView: UICollectionView) -> CGFloat {
        return 0
    }
    
}

//MARK: final public functions
public extension NKCollectionSection {
    public final func update(models: [NKDiffable], for collectionView: UICollectionView, at section: Int) {
        
        let diff = Dwifft.diff(oldModels: self.models, newModels: models)
        if diff.results.count > 0 {
            collectionView.performBatchUpdates({
                self.models = models
                let insertIndexPaths = diff.insertions.map {IndexPath.init(row: $0.idx, section: section) }
                let deleteIndexPaths = diff.deletions.map {IndexPath.init(row: $0.idx, section: section)}
                
                collectionView.insertItems(at: insertIndexPaths)
                collectionView.deleteItems(at: deleteIndexPaths)
            }, completion: nil)
        }
        
        //print("update models: \(models) inSection:\(section)")
    }
    
    public final func update(headerModel model: Any?, for collectionView: UICollectionView, at section: Int) {
        self.headerModel = model
        
        self.invalidteSupplementaryView(of: UICollectionElementKindSectionHeader, of: collectionView, at: section)
        //print("update headerModel: \(model)")
    }
    
    public final func update(footerModel model: Any?, for collectionView: UICollectionView, at section: Int) {
        self.footerModel = model
        
        self.invalidteSupplementaryView(of: UICollectionElementKindSectionFooter, of: collectionView, at: section)
        //print("update footerModel: \(model)")
    }
    
    public final func update(header: NKCollectionSupplementaryViewConfigurable.Type?, for collectionView: UICollectionView, at section: Int) {
        self.headerConfiguarationType = header
        
        if let headerConfiguration = header {
            collectionView.register(headerConfiguration, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerConfiguration.identifier)
        }
        
        self.invalidteSupplementaryView(of: UICollectionElementKindSectionHeader, of: collectionView, at: section)
    }
    
    public final func update(footer: NKCollectionSupplementaryViewConfigurable.Type?, for collectionView: UICollectionView, at section: Int) {
        self.footerConfiguarationType = footer
        
        if let footerConfiguration = footer {
            collectionView.register(footerConfiguarationType, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerConfiguration.identifier)
        }
        
        self.invalidteSupplementaryView(of: UICollectionElementKindSectionHeader, of: collectionView, at: section)
    }
    
    public final func update(headerModel model: Any?, for collectionView: UICollectionView) {
        self.headerModel = model
        
        self.invalidateLayout(of: collectionView)
        //print("update headerModel: \(model)")
    }
    
    public final func update(footerModel model: Any?, for collectionView: UICollectionView) {
        self.footerModel = model
        
        self.invalidateLayout(of: collectionView)
        //print("update footerModel: \(model)")
    }
    
    public final func update(header: NKCollectionSupplementaryViewConfigurable.Type?, for collectionView: UICollectionView) {
        self.headerConfiguarationType = header
        
        if let headerConfiguration = header {
            collectionView.register(headerConfiguration, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerConfiguration.identifier)
        }
        
        self.invalidateLayout(of: collectionView)
    }
    
    public final func update(footer: NKCollectionSupplementaryViewConfigurable.Type?, for collectionView: UICollectionView) {
        self.footerConfiguarationType = footer
        
        if let footerConfiguration = footer {
            collectionView.register(footerConfiguarationType, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerConfiguration.identifier)
        }
        
        self.invalidateLayout(of: collectionView)
    }
}

//MARK: Internal functions
extension NKCollectionSection {
    final func update(header: NKCollectionSupplementaryViewConfigurable.Type?) {
        self.headerConfiguarationType = header
    }
    
    final func update(footer: NKCollectionSupplementaryViewConfigurable.Type?) {
        self.footerConfiguarationType = footer
    }
}

//MARK: private functions
extension NKCollectionSection {
    func invalidteSupplementaryView(of kind: String, of collectionView: UICollectionView, at section: Int) {
        collectionView.performBatchUpdates({
            let context = UICollectionViewFlowLayoutInvalidationContext()
            context.invalidateSupplementaryElements(ofKind: kind, at: [IndexPath.init(row: 0, section: section)])
            
            collectionView.collectionViewLayout.invalidateLayout(with: context)
        }, completion: nil)
    }
    
    func invalidateLayout(of collectionView: UICollectionView) {
//        collectionView.performBatchUpdates({
//            collectionView.collectionViewLayout.invalidateLayout()
//        }, completion: nil)
    }
}
