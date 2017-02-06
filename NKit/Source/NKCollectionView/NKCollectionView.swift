//
//  NKCollectionView.swift
//  IgListKitExample
//
//  Created by Nghia Nguyen on 1/24/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class NKCollectionView: UICollectionView {
    fileprivate var cellConfigurations: [NKCollectionViewCellWrapperConfigurable] = []
    public fileprivate(set) var sections: [NKCollectionSection] = []
    
    //MARK: paging
    fileprivate var scrollViewWillBeginDraggingSubject = PublishSubject<CGPoint>()
    fileprivate var scrollViewWillEndScrollingObservable: Observable<CGPoint> {
        return Observable.from([self.scrollViewWillBeginDeceleratingSubject.asObservable() ,
                                self.scrollViewDidEndDraggingSubject.filter {$0.1 == false}.map {$0.0}]).merge()
    }
    
    fileprivate var scrollViewWillBeginDeceleratingSubject = PublishSubject<CGPoint>()
    fileprivate var scrollViewDidEndDraggingSubject = PublishSubject<(CGPoint, Bool)>()
    
    fileprivate lazy var rx_paging = Variable<Bool>(false)
    public var paging: Bool {
        get {
            return self.rx_paging.value
        }
        
        set {
            self.rx_paging.value = newValue
            if newValue {
                self.setupPaging()
            }
        }
    }
    
    public weak var nk_delegate: NKCollectionViewDelegate? = nil

    public func addSection(_ section: NKCollectionSection) {
        self.sections.append(section)
        
        if let header = section.headerConfiguarationType {
            self.register(header, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: header.identifier)
        }
        
        if let footer = section.footerConfiguarationType {
            self.register(footer, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footer.identifier)
        }
    }
    
    public func addSections(_ sections: [NKCollectionSection]) {
        sections.forEach { self.addSection($0)}
    }
    
    public func removeSection(at index: Int) {
        self.sections.remove(at: index)
    }
    
    public func removeAllSections() {
        self.sections = []
    }
    
    public func updateSection(at section: Int, with models: [NKDiffable]) {
        let s = self.getSection(with: section)
        s.update(models: models, for: self, at: section)
    }
    
    public func update(header: NKCollectionSupplementaryViewConfigurable.Type?, at section: Int) {
        let s = self.getSection(with: section)
        s.update(header: header, for: self, at: section)
    }
    
    public func update(headerModel model: Any?, at section: Int) {
        let s = self.getSection(with: section)
        
        s.update(headerModel: model, for: self, at: section)
    }
    
    public func update(footer: NKCollectionSupplementaryViewConfigurable.Type?, at section: Int) {
        let s = self.getSection(with: section)
        s.update(footer: footer, for: self, at: section)
    }
    
    public func update(footerModel model: Any?, at section: Int) {
        let s = self.getSection(with: section)
        
        s.update(footerModel: model, for: self, at: section)
    }
    
    public func updateFirstSection(withModels models: [NKDiffable]) {
        self.updateSection(at: 0, with: models)
    }
    
    public func updateFirstSection(withHeader header: NKCollectionSupplementaryViewConfigurable.Type?) {
        self.update(header: header, at: 0)
    }
    
    public func updateFirstSection(withFooter footer: NKCollectionSupplementaryViewConfigurable.Type?) {
        self.update(footer: footer, at: 0)
    }
    
    public func updateFirstSection(withHeaderModel headerModel: Any?) {
        self.update(headerModel: headerModel, at: 0)
    }
    
    public func updateFirstSection(withFooterModel footerModel: Any?) {
        self.update(footerModel: footerModel, at: 0)
    }
    
    public func registerCell<T: UICollectionViewCell>(cellType: T.Type) where T: NKCollectionViewCellConfigurable {
        let identifier = cellType.identifier
        let configuration = NKCollectionViewCellWrapperConfiguration<T>(reuseIdentifier: identifier)
        self.register(cellType, forCellWithReuseIdentifier: identifier)
        self.cellConfigurations.append(configuration)
    }
    
    //MARK: Constructor
    public convenience init(sectionOptions: [[NKBaseCollectionSectionOption]]) {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        self.addSections(sectionOptions.map { NKBaseCollectionSection.init(options: $0) })
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.delegate = self
        self.dataSource = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Datasource
extension NKCollectionView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        //print("num of sections: \(self.sections.count)")
        return self.sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard 0..<self.sections.count ~= section else {return 0}
        
        //print("in section: \(section) numItems: \(self.sections[section].models.count)")
        return self.sections[section].models.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.getModel(with: indexPath)
        let cellConfiguration = self.getCellConfiguration(withModel: model)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellConfiguration.reuseIdentifier, for: indexPath)
        
        cellConfiguration.config(collectionView: collectionView, cell: cell, model: model, indexPath: indexPath)
        
        //NPN TODO: more config fore cell
        //print("config for cell: \(cellConfiguration.reuseIdentifier) at indexPath: \(indexPath)")
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = self.getSection(with: indexPath.section)
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let headerConfigurationType = section.headerConfiguarationType else {
                fatalError("Don't exist header for indexPath:\(indexPath)")
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerConfigurationType.identifier, for: indexPath)
            
            if let headerModel = section.headerModel, let header = header as? NKCollectionSupplementaryViewConfigurable {
                header.collectionView(collectionView, configWithModel: headerModel, at: indexPath)
            }
            
            //print("setup header: \(headerConfigurationType.identifier) with model: \(section.headerModel)")
            return header
        default:
            guard let footerConfigurationType = section.footerConfiguarationType else {
                fatalError("Don't exist footer for indexPath:\(indexPath)")
            }
            
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerConfigurationType.identifier, for: indexPath)
            if let footerModel = section.footerModel, let footer = footer as? NKCollectionSupplementaryViewConfigurable {
                footer.collectionView(collectionView, configWithModel: footerModel, at: indexPath)
            }
            
            //print("setup footer: \(footerConfigurationType.identifier) with model: \(section.footerModel)")
            return footer
        }
    }
}

//MARK: Delegate
extension NKCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = self.getSection(with: indexPath.section)
        let model = self.getModel(withSection: section, row: indexPath.row)
        let cellConfiguration = self.getCellConfiguration(withModel: model)
        
        let result = cellConfiguration.size(with: collectionView, section: section, model: model)
        
        //print("size of item: \(cellConfiguration.reuseIdentifier) at indexPath:\(indexPath) is: \(result)")
        
        return result
    }    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = self.getSection(with: section)
        
        let result = section.inset(with: collectionView)
        
        //print("inset: \(result) for section:\(section)")
        return result
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let section = self.getSection(with: section)
        let result = section.minimumLineSpacing(with: collectionView)
        
        //print("minimumLineSpacing: \(result) for section:\(section)")
        return result
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let section = self.getSection(with: section)
        
        let result = section.minimumInteritemSpacing(with: collectionView)
        //print("minimumInteritemSpacing: \(result) for section:\(section)")
        
        return result
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section = self.getSection(with: section)
        if let headerConfiguration = section.headerConfiguarationType {
            let result = headerConfiguration.size(with: collectionView, section: section, model: section.headerModel)
            
            //print("referenceSizeForHeader: \(result) for section:\(section)")
            
            return result
        }
        
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let section = self.getSection(with: section)
        if let footerConfiguration = section.footerConfiguarationType {
            let result = footerConfiguration.size(with: collectionView, section: section, model: section.footerModel)
            
            //print("referenceSizeForFooter: \(result) for section:\(section)")
            
            return result
        }
        
        return .zero
    }
}

//MARK: UIScrollViewDelegate
public extension NKCollectionView {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidZoom?(scrollView)
    }
    
    
    // called on start of dragging (may require some time and or distance to move)
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.nk_delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.scrollViewDidEndDraggingSubject.onNext((scrollView.contentOffset, decelerate))
        
        self.nk_delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewWillBeginDeceleratingSubject.onNext(scrollView.contentOffset)
        self.nk_delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    {
        self.nk_delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? // return a view that will be scaled. if delegate returns nil, nothing happens
    {
        return self.nk_delegate?.viewForZooming?(in: scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) // called before the scroll view begins zooming its content
    {
        self.nk_delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) // scale between minimum and maximum. called after any 'bounce' animations
    {
        self.nk_delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool // return a yes if you want to scroll to the top. if not defined, assumes YES
    {
        return self.nk_delegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) // called when scrolling animation finished. may be called immediately if already at top
    {
        self.nk_delegate?.scrollViewDidScrollToTop?(scrollView)
    }
}

//MARK: UICollectionViewDelegate
public extension NKCollectionView {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.collectionView?(collectionView, shouldHighlightItemAt: indexPath) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, didHighlightItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, didUnhighlightItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.collectionView?(collectionView, shouldSelectItemAt: indexPath) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
            return self.nk_delegate?.collectionView?(collectionView, shouldDeselectItemAt: indexPath) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, didDeselectItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, willDisplaySupplementaryView: view, forElementKind: elementKind, at: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, didEndDisplayingSupplementaryView: view, forElementOfKind: elementKind, at: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.collectionView?(collectionView, shouldShowMenuForItemAt: indexPath) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return self.nk_delegate?.collectionView?(collectionView, canPerformAction: action, forItemAt: indexPath, withSender: sender) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        self.nk_delegate?.collectionView?(collectionView, performAction: action, forItemAt: indexPath, withSender: sender)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        return self.nk_delegate?.collectionView?(collectionView, transitionLayoutForOldLayout: fromLayout, newLayout: toLayout) ?? UICollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
    }
    
    public func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.collectionView?(collectionView, canFocusItemAt: indexPath) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        return self.nk_delegate?.collectionView?(collectionView, shouldUpdateFocusIn: context) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        self.nk_delegate?.collectionView?(collectionView, didUpdateFocusIn: context, with: coordinator)
    }
    
    public func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return self.nk_delegate?.indexPathForPreferredFocusedView?(in: collectionView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        return self.nk_delegate?.collectionView?(collectionView, targetIndexPathForMoveFromItemAt: originalIndexPath, toProposedIndexPath: proposedIndexPath) ?? proposedIndexPath
    }
    
    public func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return self.nk_delegate?.collectionView?(collectionView, targetContentOffsetForProposedContentOffset: proposedContentOffset) ?? proposedContentOffset
    }
}

//MARK: internal functions
extension NKCollectionView {
    func getCellConfiguration(withModel model: NKDiffable) -> NKCollectionViewCellWrapperConfigurable {
        guard let cellConfiguration = self.cellConfigurations.nk_firstMap({$0.isMe(model: model)}) else {
            fatalError("Can't find cell configuration with model: \(model)")
        }
        
        return cellConfiguration
    }
    
    func getCellConfiguration(with indexPath: IndexPath) -> NKCollectionViewCellWrapperConfigurable {
        let model = self.getModel(with: indexPath)
        return self.getCellConfiguration(withModel: model)
    }
    
    func getSection(with sectionIndex: Int) -> NKCollectionSection {
        guard 0..<self.sections.count ~= sectionIndex else {
            fatalError("Out of section range: [0..\(self.sections.count - 1)] indexPath:\(indexPath)")
        }
        
        let section = self.sections[sectionIndex]
        return section
    }
    
    func getModel(with indexPath: IndexPath) -> NKDiffable {
        
        let section = self.getSection(with: indexPath.section)
        
        return self.getModel(withSection: section, row: indexPath.row)
    }
    
    func getModel(withSection section: NKCollectionSection, row: Int) -> NKDiffable {
        guard 0..<section.models.count ~= row else {
            fatalError("Out of row range: [0..\(section.models.count - 1)] indexPath:\(indexPath)")
        }
        
        let model = section.models[row]
        
        return model
    }
}

//MARK: Paging
fileprivate extension NKCollectionView {
    fileprivate func setupPaging() {
        var startedOffset: CGPoint? = nil
        
        self.nk_scrollViewWillBeginDraggingObservable
            .takeUntil(self.rx_paging.asObservable().filter({$0 == false}))
            .subscribe(onNext: {(point) in
                startedOffset = point
            }).addDisposableTo(self.nk_disposeBag)
        
        self.nk_scrollViewWillEndScrollingObservable
            .takeUntil(self.rx_paging.asObservable().filter({$0 == false}))
            .bindNext { [unowned self] (point) in
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
}
