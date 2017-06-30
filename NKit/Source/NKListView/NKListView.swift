//
//  NKListView.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/10/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKListView {
    var view: UIScrollView {get}
    
    var actionHandler: ((NKAction) -> Void)? {get}
    
    func batchUpdates(animation: UITableViewRowAnimation, updates: (() -> Swift.Void)?, completion: ((Bool) -> Swift.Void)?)
    
    func insertItems(at indexPaths: [IndexPath], animation: UITableViewRowAnimation)
    func deleteItems(at indexPaths: [IndexPath], animation: UITableViewRowAnimation)
    
    func invalidateSupplementaryView(of kind: String, at section: Int)
    
    func invalidateLayout()
    
    func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String)
    
    func registerHeader(_ viewClass: Swift.AnyClass?, forHeaderWithReuseIdentifier identifier: String)
    
    func registerFooter(_ viewClass: Swift.AnyClass?, forFooterWithReuseIdentifier identifier: String)
    
    func reloadData()
}

extension NKListView {
    var internalListView: NKInternalListView {
        return self as! NKInternalListView
    }
}

public extension NKListView {
    public func addSection(_ section: NKListSection) {
        guard let internalListView = self as? NKInternalListView else {return}
        internalListView.sections.append(section)
        
        if let header = section.headerConfiguarationType {
            self.registerHeader(header, forHeaderWithReuseIdentifier: header.identifier)
        }
        
        if let footer = section.footerConfiguarationType {
            self.registerFooter(footer, forFooterWithReuseIdentifier: footer.identifier)
        }
    }
    
    public func addSections(_ sections: [NKListSection]) {
        sections.forEach { self.addSection($0)}
    }
    
    public func removeSection(at index: Int) {
        self.internalListView.sections.remove(at: index)
    }
    
    public func removeAllSections() {
        
        self.internalListView.sections = []
    }
    
    public func updateSection(at section: Int, with models: [NKDiffable]) {
        let s = self.internalListView.getSection(with: section)
        s.update(models: models, for: self, at: section)
    }
    
    public func update(header: NKListSupplementaryViewConfigurable.Type?, at section: Int) {
        let s = self.internalListView.getSection(with: section)
        s.update(header: header, for: self, at: section)
    }
    
    public func update(headerModel model: Any?, at section: Int) {
        let s = self.internalListView.getSection(with: section)
        
        s.update(headerModel: model, for: self, at: section)
    }
    
    public func update(footer: NKListSupplementaryViewConfigurable.Type?, at section: Int) {
        let s = self.internalListView.getSection(with: section)
        s.update(footer: footer, for: self, at: section)
    }
    
    public func update(footerModel model: Any?, at section: Int) {
        let s = self.internalListView.getSection(with: section)
        
        s.update(footerModel: model, for: self, at: section)
    }
    
    public func updateFirstSection(withModels models: [NKDiffable]) {
        self.updateSection(at: 0, with: models)
    }
    
    public func updateFirstSection(withHeader header: NKListSupplementaryViewConfigurable.Type?) {
        self.update(header: header, at: 0)
    }
    
    public func updateFirstSection(withFooter footer: NKListSupplementaryViewConfigurable.Type?) {
        self.update(footer: footer, at: 0)
    }
    
    public func updateFirstSection(withHeaderModel headerModel: Any?) {
        self.update(headerModel: headerModel, at: 0)
    }
    
    public func updateFirstSection(withFooterModel footerModel: Any?) {
        self.update(footerModel: footerModel, at: 0)
    }
    
    public func register<T: UIView>(cellType: T.Type) where T: NKListViewCellConfigurable {
        let identifier = cellType.identifier
        let configuration = NKListViewCellWrapperConfiguration<T>(reuseIdentifier: identifier)
        self.register(cellType, forCellWithReuseIdentifier: identifier)
        self.internalListView.cellConfigurations.append(configuration)
    }
}

protocol NKInternalListView: class, NKListView {
    var cellConfigurations: [NKListViewCellWrapperConfigurable] {get set}
    var sections: [NKListSection] {get set}
}

extension NKInternalListView {
    func getCellConfiguration(withModel model: NKDiffable) -> NKListViewCellWrapperConfigurable {
        guard let cellConfiguration = self.cellConfigurations.nk_firstMap({$0.isMe(model: model)}) else {
            fatalError("Can't find cell configuration with model: \(model)")
        }
        
        return cellConfiguration
    }
    
    func getCellConfiguration(with indexPath: IndexPath) -> NKListViewCellWrapperConfigurable {
        let model = self.getModel(with: indexPath)
        return self.getCellConfiguration(withModel: model)
    }
    
    func getSection(with sectionIndex: Int) -> NKListSection {
        guard 0..<self.sections.count ~= sectionIndex else {
            fatalError("Out of section range: [0..\(self.sections.count - 1)] index:\(sectionIndex)")
        }
        
        let section = self.sections[sectionIndex]
        return section
    }
    
    func getModel(with indexPath: IndexPath) -> NKDiffable {
        
        let section = self.getSection(with: indexPath.section)
        
        return self.getModel(withSection: section, row: indexPath.row)
    }
    
    func getModel(withSection section: NKListSection, row: Int) -> NKDiffable {
        guard 0..<section.models.count ~= row else {
            fatalError("Out of row range: [0..\(section.models.count - 1)] row:\(row)")
        }
        
        let model = section.models[row]
        
        return model
    }
}

extension NKCollectionView: NKInternalListView {}

extension NKCollectionView: NKListView {
    public var view: UIScrollView {
        return self
    }
    
    public func batchUpdates(animation: UITableViewRowAnimation, updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        
        let doUpdates: () -> Void = {
            self.performBatchUpdates(updates, completion: completion)
        }
        
        if animation == .none {
            UIView.animate(withDuration: 0, animations: {
                doUpdates()
            })
        } else {
            doUpdates()
        }
    }
    
    public func insertItems(at indexPaths: [IndexPath], animation: UITableViewRowAnimation) {
        self.insertItems(at: indexPaths)
    }
    
    public func deleteItems(at indexPaths: [IndexPath], animation: UITableViewRowAnimation) {
        self.deleteItems(at: indexPaths)
    }
    
    public func invalidateSupplementaryView(of kind: String, at section: Int) {
        self.performBatchUpdates({
            let context = UICollectionViewFlowLayoutInvalidationContext()
            context.invalidateSupplementaryElements(ofKind: kind, at: [IndexPath.init(row: 0, section: section)])
            
            self.collectionViewLayout.invalidateLayout(with: context)
        }, completion: nil)
    }
    
    public func invalidateLayout() {
        //NPN TODO: implement later
    }
    
    public func registerHeader(_ viewClass: Swift.AnyClass?, forHeaderWithReuseIdentifier identifier: String) {
        self.register(viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    public func registerFooter(_ viewClass: Swift.AnyClass?, forFooterWithReuseIdentifier identifier: String) {
        self.register(viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier)
    }
}

extension NKTableView: NKInternalListView {}
extension NKTableView: NKListView {
    public var view: UIScrollView {
        return self
    }
    
    public func batchUpdates(animation: UITableViewRowAnimation, updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        let doUpdates: () -> Void = { [weak self] in
            self?.beginUpdates()
            updates?()
            self?.endUpdates()
            completion?(true)
        }
        
        if animation == .none {
            UIView.animate(withDuration: 0, animations: {
                doUpdates()
            })
        } else {
            doUpdates()
        }
    }
    
    public func insertItems(at indexPaths: [IndexPath], animation: UITableViewRowAnimation) {
        self.insertRows(at: indexPaths, with: animation)
    }
    
    public func deleteItems(at indexPaths: [IndexPath], animation: UITableViewRowAnimation) {
        self.deleteRows(at: indexPaths, with: animation)
    }
    
    public func invalidateSupplementaryView(of kind: String, at section: Int) {
        var view: UIView?
        var model: Any?
        let s = self.getSection(with: section)
        switch kind {
        case UICollectionElementKindSectionFooter:
            view = self.footerView(forSection: section)
            model = s.footerModel
            
        case UICollectionElementKindSectionHeader:
            view = self.headerView(forSection: section)
            model = s.headerModel
        default:
            break
        }
        
        view?.setNeedsDisplay()
        if let view = view as? NKListSupplementaryViewConfigurable, let model = model {
            view.listView(self, configWithModel: model, at: section)
        }

    }
    
    public func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    public func invalidateLayout() {
        //NPN TODO: implement later
    }
    
    public func registerHeader(_ viewClass: Swift.AnyClass?, forHeaderWithReuseIdentifier identifier: String) {
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func registerFooter(_ viewClass: Swift.AnyClass?, forFooterWithReuseIdentifier identifier: String) {
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
}

