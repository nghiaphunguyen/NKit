//
//  NKCollectionView.swift
//  IgListKitExample
//
//  Created by Nghia Nguyen on 1/24/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import NRxSwift
import RxCocoa

public var NKCollectionViewAutomaticSize: CGSize { return CGSize(width: 1, height: 1) }

open class NKCollectionView: UICollectionView {
    internal var cellConfigurations: [NKListViewCellWrapperConfigurable] = []
    public internal(set) var sections: [NKListSection] = []
    
    //MARK: paging
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
    
    fileprivate var rx_currentPage = Variable<Int>(0)
    public var currentPage: NKVariable<Int> {
        return self.rx_currentPage.nk_variable
    }
    
    public weak var nk_delegate: NKCollectionViewDelegate? = nil
    
    //MARK: Constructor
    public convenience init(sectionOptions: [[NKBaseCollectionSectionOption]]) {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        self.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        
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
    
    dynamic open func setCurrentPage(_ page: Int) {
        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let isHorizontal = layout.scrollDirection == .horizontal
        
        let page = max(0, min(page, (self.sections.first?.models.count ?? 0) - 1))
        let minOffset: CGFloat = 0
        
        let maxOffset = isHorizontal ? self.contentSize.width - self.nk_width : self.contentSize.height - self.nk_height
        
        let itemSize = isHorizontal ? layout.itemSize.width : layout.itemSize.height
        let spacing = isHorizontal ? layout.minimumInteritemSpacing : layout.minimumLineSpacing
        let inset = isHorizontal ? layout.sectionInset.left : layout.sectionInset.top
        let viewSize = isHorizontal ? self.nk_width : self.nk_height
        let value = itemSize + spacing
        let firstValue = 3 * itemSize / 2 + spacing + inset - viewSize / 2
        
        let newOffset = max(minOffset, min(CGFloat(page - 1) * value + (page > 0 ? firstValue : 0), maxOffset))
        let newPoint = isHorizontal ? CGPoint(x: newOffset, y: 0) : CGPoint(x: 0, y: newOffset)
        
        //print("Page=\(page) newOffset=\(newOffset) value=\(value) firstvalue=\(value) itemSize:\(itemSize) viewSize:\(viewSize)")
        self.setContentOffset(newPoint, animated: true)
        self.rx_currentPage.nk_asyncSet(value: page)
    }
}

//MARK: Datasource
extension NKCollectionView: UICollectionViewDataSource {
    dynamic open func numberOfSections(in collectionView: UICollectionView) -> Int {
        ////print("num of sections: \(self.sections.count)")
        return self.sections.count
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard 0..<self.sections.count ~= section else {return 0}
        
        //print("in section: \(section) numItems: \(self.sections[section].models.count)")
        return self.sections[section].models.count
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.getModel(with: indexPath)
        let cellConfiguration = self.getCellConfiguration(withModel: model)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellConfiguration.reuseIdentifier, for: indexPath)
        
        cellConfiguration.config(listView: self, cell: cell, model: model, indexPath: indexPath)
        
        //NPN TODO: more config fore cell
        ////print("config for cell: \(cellConfiguration.reuseIdentifier) at indexPath: \(indexPath)")
        return cell
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = self.getSection(with: indexPath.section)
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let headerConfigurationType = section.headerConfiguarationType else {
                fatalError("Don't exist header for indexPath:\(indexPath)")
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerConfigurationType.identifier, for: indexPath)
            
            if let headerModel = section.headerModel, let header = header as? NKListSupplementaryViewConfigurable {
                header.listView(self, configWithModel: headerModel, at: indexPath.section)
            }
            
            ////print("setup header: \(headerConfigurationType.identifier) with model: \(section.headerModel)")
            return header
        default:
            guard let footerConfigurationType = section.footerConfiguarationType else {
                fatalError("Don't exist footer for indexPath:\(indexPath)")
            }
            
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerConfigurationType.identifier, for: indexPath)
            if let footerModel = section.footerModel, let footer = footer as? NKListSupplementaryViewConfigurable {
                footer.listView(self, configWithModel: footerModel, at: indexPath.section)
            }
            
            ////print("setup footer: \(footerConfigurationType.identifier) with model: \(section.footerModel)")
            return footer
        }
    }
}

//MARK: Delegate
extension NKCollectionView: UICollectionViewDelegateFlowLayout {
    dynamic open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = self.getSection(with: indexPath.section)
        let model = self.getModel(withSection: section, row: indexPath.row)
        let cellConfiguration = self.getCellConfiguration(withModel: model)
        
        let result = cellConfiguration.size(with: self, section: section, model: model)
        
        //print("size of item: \(cellConfiguration.reuseIdentifier) at indexPath:\(indexPath) is: \(result)")
        
        return result.size
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let section = self.getSection(with: section) as? NKCollectionSection {
            return section.inset(with: collectionView)
        }
        
        return .zero
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let section = self.getSection(with: section) as? NKCollectionSection else {
            return 0
        }
        
        let result = section.minimumLineSpacing(with: collectionView)
        
        ////print("minimumLineSpacing: \(result) for section:\(section)")
        return result
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard let section = self.getSection(with: section) as? NKCollectionSection else {
            return 0
        }
        
        let result = section.minimumInteritemSpacing(with: collectionView)
        ////print("minimumInteritemSpacing: \(result) for section:\(section)")
        
        return result
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section = self.getSection(with: section)
        if let headerConfiguration = section.headerConfiguarationType {
            let result = headerConfiguration.size(with: self, section: section, model: section.headerModel)
            
            ////print("referenceSizeForHeader: \(result) for section:\(section)")
            
            return result.size
        }
        
        return .zero
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let section = self.getSection(with: section)
        if let footerConfiguration = section.footerConfiguarationType {
            let result = footerConfiguration.size(with: self, section: section, model: section.footerModel)
            
            ////print("referenceSizeForFooter: \(result) for section:\(section)")
            
            return result.size
        }
        
        return .zero
    }

    dynamic open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidScroll?(scrollView)
    }
    
    dynamic open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidZoom?(scrollView)
    }
    
    
    // called on start of dragging (may require some time and or distance to move)
    dynamic open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
    dynamic open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.nk_delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    dynamic open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.nk_delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    dynamic open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    dynamic open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    dynamic open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    {
        self.nk_delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    dynamic open func viewForZooming(in scrollView: UIScrollView) -> UIView? // return a view that will be scaled. if delegate returns nil, nothing happens
    {
        return self.nk_delegate?.viewForZooming?(in: scrollView)
    }
    
    dynamic open func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) // called before the scroll view begins zooming its content
    {
        self.nk_delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    dynamic open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) // scale between minimum and maximum. called after any 'bounce' animations
    {
        self.nk_delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    dynamic open func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool // return a yes if you want to scroll to the top. if not defined, assumes YES
    {
        return self.nk_delegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }
    
    dynamic open func scrollViewDidScrollToTop(_ scrollView: UIScrollView) // called when scrolling animation finished. may be called immediately if already at top
    {
        self.nk_delegate?.scrollViewDidScrollToTop?(scrollView)
    }

    dynamic open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.collectionView?(collectionView, shouldHighlightItemAt: indexPath) ?? true
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, didHighlightItemAt: indexPath)
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, didUnhighlightItemAt: indexPath)
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.collectionView?(collectionView, shouldSelectItemAt: indexPath) ?? true
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.collectionView?(collectionView, shouldDeselectItemAt: indexPath) ?? true
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, didDeselectItemAt: indexPath)
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, willDisplaySupplementaryView: view, forElementKind: elementKind, at: indexPath)
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        self.nk_delegate?.collectionView?(collectionView, didEndDisplayingSupplementaryView: view, forElementOfKind: elementKind, at: indexPath)
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.collectionView?(collectionView, shouldShowMenuForItemAt: indexPath) ?? false
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return self.nk_delegate?.collectionView?(collectionView, canPerformAction: action, forItemAt: indexPath, withSender: sender) ?? true
    }
    
    dynamic open func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        self.nk_delegate?.collectionView?(collectionView, performAction: action, forItemAt: indexPath, withSender: sender)
    }
    
    
    dynamic open func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        return self.nk_delegate?.collectionView?(collectionView, transitionLayoutForOldLayout: fromLayout, newLayout: toLayout) ?? UICollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
    }
    
    @available(iOS 9.0, *)
    dynamic open func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.collectionView?(collectionView, canFocusItemAt: indexPath) ?? true
    }
    
    @available(iOS 9.0, *)
    dynamic open func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        return self.nk_delegate?.collectionView?(collectionView, shouldUpdateFocusIn: context) ?? true
    }
    
    @available(iOS 9.0, *)
    dynamic open func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        self.nk_delegate?.collectionView?(collectionView, didUpdateFocusIn: context, with: coordinator)
    }
    
    @available(iOS 9.0, *)
    dynamic open func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return self.nk_delegate?.indexPathForPreferredFocusedView?(in: collectionView)
    }
    
    @available(iOS 9.0, *)
    dynamic open func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        return self.nk_delegate?.collectionView?(collectionView, targetIndexPathForMoveFromItemAt: originalIndexPath, toProposedIndexPath: proposedIndexPath) ?? proposedIndexPath
    }
    
    @available(iOS 9.0, *)
    dynamic open func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return self.nk_delegate?.collectionView?(collectionView, targetContentOffsetForProposedContentOffset: proposedContentOffset) ?? proposedContentOffset
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
        
        self.nk_scrollViewDidEndScrollingObservable
            .takeUntil(self.rx_paging.asObservable().filter({$0 == false}))
            .bindNext { [weak self] (point) in
                guard let sSelf = self else {return}
                guard let layout = sSelf.collectionViewLayout as? UICollectionViewFlowLayout else {
                    return
                }
                
                let isHorizontal = layout.scrollDirection == .horizontal
                
                let itemSize = isHorizontal ? layout.itemSize.width : layout.itemSize.height
                let spacing = isHorizontal ? layout.minimumInteritemSpacing : layout.minimumLineSpacing
                let inset = isHorizontal ? layout.sectionInset.left : layout.sectionInset.top
                let viewSize = isHorizontal ? sSelf.nk_width : sSelf.nk_height
                let value = itemSize + spacing
                let firstValue = 3 * itemSize / 2 + spacing + inset - viewSize / 2
                
                let sOffset = (isHorizontal ? startedOffset?.x : startedOffset?.y) ?? 0
                let offset = isHorizontal ? point.x : point.y
                
                let currentPage: Int
                if offset >= firstValue {
                    currentPage = Int((offset - firstValue) / value) + 1
                } else {
                    currentPage = 0
                }
                
                let k = offset > sOffset ? 1 : 0
                
                let page = currentPage + k
                
                sSelf.setCurrentPage(page)
            }.addDisposableTo(self.nk_disposeBag)
    }
}
