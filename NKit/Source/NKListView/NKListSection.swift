//
//  NKListSection.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/10/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import Diff

open class NKListSection: NSObject {
    open var models: [NKDiffable] = []
    open fileprivate(set) var headerModel: Any? = nil
    open fileprivate(set) var footerModel: Any? = nil
    
    var headerConfiguarationType: NKListSupplementaryViewConfigurable.Type? = nil
    
    var footerConfiguarationType: NKListSupplementaryViewConfigurable.Type? = nil
    
    open var animation: UITableViewRowAnimation {
        return .none
    }
}

private var backgroundQueue = DispatchQueue.init(label: "diff")

public extension NKListSection {
    
    public final func update(models: [NKDiffable], for listView: NKListView, at section: Int) {
        
        backgroundQueue.async { [weak self] in
            guard let sSelf = self else {return}
            
            if sSelf.models.count == 0 || models.count == 0 {
                // reload
                DispatchQueue.main.async {
                    sSelf.models = models
                    listView.reloadData()
                }
                
                return
            }
            
            let diff = sSelf.models.diff(models)
            if diff.elements.count > 0 {
                DispatchQueue.main.sync {
                    listView.batchUpdates(animation: sSelf.animation, updates: { [weak self] in
                        guard let sSelf = self else {return}

                        sSelf.models = models
                        let insertIndexPaths = diff.insertions.map {IndexPath.init(row: $0.idx, section: section) }
                        let deleteIndexPaths = diff.deletions.map {IndexPath.init(row: $0.idx, section: section)}
                        
                        listView.insertItems(at: insertIndexPaths, animation: sSelf.animation)
                        listView.deleteItems(at: deleteIndexPaths, animation: sSelf.animation)
                        
                        }, completion: nil)
                }
            }
        }
        
        //print("update models: \(models) inSection:\(section)")
    }
    
    public final func update(headerModel model: Any?, for listView: NKListView, at section: Int) {
        self.headerModel = model
        
        listView.invalidateSupplementaryView(of: UICollectionElementKindSectionHeader, at: section)
        //print("update headerModel: \(model)")
    }
    
    public final func update(footerModel model: Any?, for listView: NKListView, at section: Int) {
        self.footerModel = model
        listView.invalidateSupplementaryView(of: UICollectionElementKindSectionFooter, at: section)
        //print("update footerModel: \(model)")
    }
    
    public final func update(header: NKListSupplementaryViewConfigurable.Type?, for listView: NKListView, at section: Int) {
        self.headerConfiguarationType = header
        
        if let headerConfiguration = header {
            listView.registerHeader(headerConfiguration, forHeaderWithReuseIdentifier: headerConfiguration.identifier)
        }
        
        listView.invalidateSupplementaryView(of: UICollectionElementKindSectionHeader, at: section)
    }
    
    public final func update(footer: NKListSupplementaryViewConfigurable.Type?, for listView: NKListView, at section: Int) {
        self.footerConfiguarationType = footer
        
        if let footerConfiguration = footer {
            listView.registerFooter(footerConfiguration, forFooterWithReuseIdentifier: footerConfiguration.identifier)
        }
        
        listView.invalidateSupplementaryView(of: UICollectionElementKindSectionFooter, at: section)
    }
    
    public final func update(headerModel model: Any?, for listView: NKListView) {
        self.headerModel = model
        
        listView.invalidateLayout()
        //print("update headerModel: \(model)")
    }
    
    public final func update(footerModel model: Any?, for listView: NKListView) {
        self.footerModel = model
        
        listView.invalidateLayout()
        //print("update footerModel: \(model)")
    }
    
    public final func update(header: NKListSupplementaryViewConfigurable.Type?, for listView: NKListView) {
        self.headerConfiguarationType = header
        
        if let headerConfiguration = header {
            listView.registerHeader(headerConfiguration, forHeaderWithReuseIdentifier: headerConfiguration.identifier)
        }
        
        listView.invalidateLayout()
    }
    
    public final func update(footer: NKListSupplementaryViewConfigurable.Type?, for listView: NKListView) {
        self.footerConfiguarationType = footer
        
        if let footerConfiguration = footer {
            listView.registerFooter(footerConfiguration, forFooterWithReuseIdentifier: footerConfiguration.identifier)
        }
        
        listView.invalidateLayout()
    }
}

//MARK: Internal functions
extension NKListSection {
    final func update(header: NKListSupplementaryViewConfigurable.Type?) {
        self.headerConfiguarationType = header
    }
    
    final func update(footer: NKListSupplementaryViewConfigurable.Type?) {
        self.footerConfiguarationType = footer
    }
}
