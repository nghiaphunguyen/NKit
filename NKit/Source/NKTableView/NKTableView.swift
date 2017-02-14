//
//  NKTableView.swift
//  FastSell
//
//  Created by Nghia Nguyen on 4/18/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import UIKit
import RxSwift
import NRxSwift

public var NKTableViewAutomaticHeight: CGFloat { return 2 }

open class NKTableView: UITableView {
    internal var cellConfigurations: [NKListViewCellWrapperConfigurable] = []
    public internal(set) var sections: [NKListSection] = []
    
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
    
    public var nk_delegate: NKTableViewDelegate? = nil
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.dataSource = self
        self.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NKTableView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard 0..<self.sections.count ~= section else {return 0}
        
        return self.sections[section].models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.getModel(with: indexPath)
        let cellConfiguartion = self.getCellConfiguration(with: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConfiguartion.reuseIdentifier, for: indexPath)
        cellConfiguartion.config(listView: self, cell: cell, model: model, indexPath: indexPath)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.tableView?(tableView, canEditRowAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.tableView?(tableView, canMoveRowAt: indexPath) ?? false
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.nk_delegate?.sectionIndexTitles?(for: tableView) ?? nil
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.nk_delegate?.tableView?(tableView, sectionForSectionIndexTitle: title, at: index) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
}

extension NKTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        self.nk_delegate?.tableView?(tableView, willDisplayHeaderView: view, forSection: section)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        self.nk_delegate?.tableView?(tableView, willDisplayFooterView: view, forSection: section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        self.nk_delegate?.tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        self.nk_delegate?.tableView?(tableView, didEndDisplayingFooterView: view, forSection: section)
    }
    
    // Variable height support
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.getSection(with: indexPath.section)
        let model = self.getModel(withSection: section, row: indexPath.row)
        let cellConfiguration = self.getCellConfiguration(withModel: model)
        let result = cellConfiguration.size(with: self, section: section, model: model)
        return result.height
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = self.getSection(with: section)
        if let headerConfiguration = section.headerConfiguarationType {
            let result = headerConfiguration.size(with: self, section: section, model: section.headerModel)
            
            return result.height
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = self.getSection(with: section)
        if let footerConfiguration = section.footerConfiguarationType {
            let result = footerConfiguration.size(with: self, section: section, model: section.footerModel)
            
            return result.height
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let s = self.getSection(with: section)
        guard let configurationType = s.headerConfiguarationType else {return nil}
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: configurationType.identifier)
        
        if let view = view as? NKListSupplementaryViewConfigurable, let model = s.headerModel {
            view.listView(self, configWithModel: model, at: section)
        }
        
        return view
    }// custom view for header. will be adjusted to default or specified header height
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let s = self.getSection(with: section)
        guard let configurationType = s.footerConfiguarationType else {return nil}
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: configurationType.identifier)
        
        if let view = view as? NKListSupplementaryViewConfigurable, let model = s.footerModel {
            view.listView(self, configWithModel: model, at: section)
        }
        
        return view
    }// custom view for footer. will be adjusted to default or
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, accessoryButtonTappedForRowWith: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.tableView?(tableView, shouldHighlightRowAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, didHighlightRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, didUnhighlightRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return self.nk_delegate?.tableView?(tableView, willSelectRowAt: indexPath) ?? indexPath
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return self.nk_delegate?.tableView?(tableView, willDeselectRowAt: indexPath) ?? indexPath
    }
    
    // Called after the user changes the selection.
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    // Editing
    
    // Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return self.nk_delegate?.tableView?(tableView, editingStyleForRowAt: indexPath) ?? .none
    }
    
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return self.nk_delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath) ?? nil
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return self.nk_delegate?.tableView?(tableView, editActionsForRowAt: indexPath) ?? nil
    }// supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
    
    
    // Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.tableView?(tableView, shouldIndentWhileEditingRowAt: indexPath) ?? false
    }
    
    // The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, willBeginEditingRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.nk_delegate?.tableView?(tableView, didEndEditingRowAt: indexPath)
    }
    
    
    // Moving/reordering
    
    // Allows customization of the target row for a particular row as it is being moved/reordered
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return self.nk_delegate?.tableView?(tableView, targetIndexPathForMoveFromRowAt: sourceIndexPath, toProposedIndexPath: proposedDestinationIndexPath) ?? proposedDestinationIndexPath
    }
    
    // Indentation
    public func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return self.nk_delegate?.tableView?(tableView, indentationLevelForRowAt: indexPath) ?? 0
        //NPN TODO: check this
    }// return 'depth' of row for hierarchies
    
    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.tableView?(tableView, shouldShowMenuForRowAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return self.nk_delegate?.tableView?(tableView, canPerformAction: action, forRowAt: indexPath, withSender: sender) ?? false
    }
    
    public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        self.nk_delegate?.tableView?(tableView, performAction: action, forRowAt: indexPath, withSender: sender)
    }
    
    // Focus
    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.tableView?(tableView, canFocusRowAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return self.nk_delegate?.tableView?(tableView, shouldUpdateFocusIn: context) ?? false
    }
    
    public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        self.nk_delegate?.tableView?(tableView, didUpdateFocusIn: context, with: coordinator)
    }
    
    public func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return self.nk_delegate?.indexPathForPreferredFocusedView?(in: tableView) ?? nil
    }
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidScroll?(scrollView)
    }// any offset changes
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidZoom?(scrollView)
    }// any zoom scale changes
    
    
    // called on start of dragging (may require some time and or distance to move)
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollViewWillBeginDraggingSubject.onNext(scrollView.contentOffset)
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
    }// called on finger up as we are moving
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidEndDecelerating?(scrollView)
    }// called when scroll view grinds to a halt
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.nk_delegate?.viewForZooming?(in: scrollView) ?? nil
    }// return a view that will be scaled. if delegate returns nil, nothing happens
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.nk_delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }// called before the scroll view begins zooming its content
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.nk_delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }// scale between minimum and maximum. called after any 'bounce' animations
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return self.nk_delegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }// return a yes if you want to scroll to the top. if not defined, assumes YES
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidScrollToTop?(scrollView)
    }
}

//open class NKTableView: UITableView {
//    public override init(frame: CGRect, style: UITableViewStyle) {
//        super.init(frame: frame, style: style)
//        
//        
//    }
//}
//
//extension NKTableView: UITableViewDataSource {
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//    }
//}
//
//extension NKTableView: UITableViewDelegate {
//    
//}


//import NATTableView
//
////MARK: - Constants
//private extension NKTableView {
//    struct Constant {
//        static var EstimatedRowHeight: CGFloat {return 50}
//    }
//}
//
////MARK: - Properties
//open class NKTableView: ATTableView {
//    
//    //private properties
//    
//    lazy var preHeight: CGFloat? = nil
//    
//    open var cellHeightToFit = false {
//        didSet {
//            self.estimatedRowHeight = Constant.EstimatedRowHeight
//            self.rowHeight = UITableViewAutomaticDimension
//            self.setNeedsLayout()
//        }
//    }
//    
//    open var isHeightToFit = false {
//        didSet {
//            self.setNeedsLayout()
//        }
//    }
//    
//    open var addMoreConfigForCell: ((_ cell: UITableViewCell, _ indexPath: IndexPath) -> Void)?
//    
//    open var separateHeight: CGFloat? //just trick to use separate views
//    
//    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//        self.addMoreConfigForCell?(cell, indexPath)
//        return cell
//    }
//    
//    open override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        if self.isHeightToFit && self.contentSize.height != self.preHeight{
//            self.snp.updateConstraints({ (make) -> Void in
//                make.height.equalTo(self.contentSize.height)
//            })
//            
//            if self.preHeight == nil || self.preHeight! <= 0 {
//                self.reloadData()
//            }
//            
//            self.preHeight = self.contentSize.height
//        }
//        
//        self.layoutIfNeeded()
//    }
//}
//
//public extension NKTableView {
//    public func reloadWithItems(items: [Any]) {
//        self.clearAll()
//        
//        if let separateHeight = self.separateHeight {
//            for (index, item) in items.enumerated() {
//                let section = ATTableViewSection()
//                section.headerHeight = separateHeight
//                section.customHeaderView = { (_) in
//                    let view = UIView()
//                    view.backgroundColor = UIColor.clear
//                    return view
//                }
//                self.addSection(section: section, atIndex: index)
//                self.addItems(items: [item], section: index)
//            }
//        } else {
//            self.addItems(items: items)
//        }
//        
//        self.reloadData()
//    }
//}


//MARK: Paging
fileprivate extension NKTableView {
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
                //NPN TODO: recheck
                let value = self.rowHeight
                
                let firstCenter = self.contentInset.top + self.rowHeight / 2
                let xFirstCenter = self.rowHeight / 2
                let firstValue = value - (xFirstCenter - firstCenter)
                
                let sOffset = startedOffset?.y ?? 0
                let offset = point.y
                let minOffset: CGFloat = 0
                
                let maxOffset = self.contentSize.height - self.nk_height
                
                let currentPage: Int
                if offset >= firstValue {
                    currentPage = Int((offset - firstValue) / value) + 1
                } else {
                    currentPage = 0
                }
                
                let k = offset > sOffset ? 1 : 0
                
                let page = currentPage + k
                
                let newOffset = max(minOffset, min(CGFloat(page - 1) * value + (page > 0 ? firstValue : 0), maxOffset))
                let newPoint = CGPoint(x: point.x, y: newOffset)
                self.setContentOffset(newPoint, animated: true)
            }.addDisposableTo(self.nk_disposeBag)
    }
}

