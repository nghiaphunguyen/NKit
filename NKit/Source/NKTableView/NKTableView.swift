//
//  NKTableView.swift
//  FastSell
//
//  Created by Nghia Nguyen on 4/18/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import UIKit
import RxSwift

public var NKTableViewAutomaticHeight: CGFloat { return 2 }

open class NKTableView: UITableView {
    internal var cellConfigurations: [NKListViewCellWrapperConfigurable] = []
    public internal(set) var sections: [NKListSection] = []
    
    public var actionHandler: ((NKAction) -> Void)? = nil
    
    fileprivate var heightsOfCell = [IndexPath : CGFloat]()
    
    public var infinityConfig: (cellHeight: CGFloat, numberOffCellInScreen: Int, itemMargin: CGFloat)? = nil
    
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
    
    public var nk_delegate: NKTableViewDelegate? = nil
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.dataSource = self
        self.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var actualPage: Int = {
        return self.rx_currentPage.value
    }()
    
    var currentOffsetY: CGFloat = 0
    
    @objc dynamic open func setCurrentPage(_ page: Int) {
        var page = page
        guard page != self.rx_currentPage.value else {return}
        
        let offsetY = self.contentOffset.y
        let itemSize = self.rowHeight
        let spacing: CGFloat = 0
        let inset = self.contentInset.top
        let viewSize = self.nk_height
        let value = itemSize + spacing
        let firstValue = 3 * itemSize / 2 + spacing + inset - viewSize / 2
        
        page = max(0, page % (self.sections.first?.models.count ?? 0))
        let modelsCount = (self.sections.first?.models.count ?? 0)
        if let config = self.infinityConfig {
            let isSideDown = offsetY > self.currentOffsetY
            self.currentOffsetY = offsetY
            
            if self.rx_currentPage.value > config.numberOffCellInScreen && page < config.numberOffCellInScreen && isSideDown {
                self.actualPage = page + modelsCount
            } else {
                if (self.actualPage >= modelsCount && page > self.rx_currentPage.value && page <= config.numberOffCellInScreen) {
                    self.actualPage += 1
                    
                    if self.actualPage > modelsCount + config.numberOffCellInScreen {
                        self.actualPage = actualPage % modelsCount
                    }
                } else {
                    self.actualPage = page
                }
            }
            
            
        } else {
            self.actualPage = page
        }
        
        let minOffset: CGFloat = 0
        
        let maxOffset = self.contentSize.height - self.nk_height
        
        let newOffset = max(minOffset, min(CGFloat(self.actualPage - 1) * value + (self.actualPage > 0 ? firstValue : 0), maxOffset))
        let newPoint = CGPoint(x: 0, y: newOffset)
        
        self.setContentOffset(newPoint, animated: true)
        self.rx_currentPage.value = page
    }
    
    fileprivate func getIndexPath(from indexPath: IndexPath) -> IndexPath {
        var indexPath = indexPath
        if self.infinityConfig.nk_isNotNil {
            let itemsCount = self.sections[indexPath.section].models.count
            if itemsCount > 0 {
                indexPath = IndexPath(row: indexPath.row % itemsCount, section: indexPath.section)
            }
        }
        return indexPath
    }
}

extension NKTableView: UITableViewDataSource {
    @objc dynamic open func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard 0..<self.sections.count ~= section else {return 0}
        
        if let config = self.infinityConfig, self.sections.count == 1 && self.sections[section].models.count > 0 {
            return self.sections[section].models.count + config.numberOffCellInScreen + 1
        } else {
            return self.sections[section].models.count
        }
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexPath = self.getIndexPath(from: indexPath)
        let model = self.getModel(with: indexPath)
        let cellConfiguartion = self.getCellConfiguration(with: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConfiguartion.reuseIdentifier, for: indexPath)
        cellConfiguartion.config(listView: self, cell: cell, model: model, indexPath: indexPath)
        
        return cell
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.tableView?(tableView, canEditRowAt: indexPath) ?? true
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.tableView?(tableView, canMoveRowAt: indexPath) ?? false
    }
    
    @objc dynamic open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.nk_delegate?.sectionIndexTitles?(for: tableView) ?? nil
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.nk_delegate?.tableView?(tableView, sectionForSectionIndexTitle: title, at: index) ?? 0
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
}

extension NKTableView: UITableViewDelegate {
    @objc dynamic open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.heightsOfCell[indexPath] = cell.nk_height
        self.nk_delegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        self.nk_delegate?.tableView?(tableView, willDisplayHeaderView: view, forSection: section)
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        self.nk_delegate?.tableView?(tableView, willDisplayFooterView: view, forSection: section)
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        self.nk_delegate?.tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        self.nk_delegate?.tableView?(tableView, didEndDisplayingFooterView: view, forSection: section)
    }
    
    // Variable height support
    @objc dynamic open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.getSection(with: indexPath.section)
        let indexPath = self.getIndexPath(from: indexPath)
        let model = self.getModel(withSection: section, row: indexPath.row)
        let cellConfiguration = self.getCellConfiguration(withModel: model)
        let result = cellConfiguration.size(with: self, section: section, model: model)
        return result.height
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightsOfCell[indexPath] ?? UITableView.automaticDimension
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = self.getSection(with: section)
        if let headerConfiguration = section.headerConfiguarationType {
            let result = headerConfiguration.size(with: self, section: section, model: section.headerModel)
            
            return result.height
        }
        
        return tableView.style == .grouped ? CGFloat.leastNormalMagnitude : 0
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = self.getSection(with: section)
        if let footerConfiguration = section.footerConfiguarationType {
            let result = footerConfiguration.size(with: self, section: section, model: section.footerModel)
            
            return result.height
        }
        
        return tableView.style == .grouped ? CGFloat.leastNormalMagnitude : 0
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let s = self.getSection(with: section)
        guard let configurationType = s.headerConfiguarationType else {return nil}
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: configurationType.identifier)
        
        if let view = view as? NKListSupplementaryViewConfigurable, let model = s.headerModel {
            view.listView(self, configWithModel: model, at: section)
        }
        
        return view
    }// custom view for header. will be adjusted to default or specified header height
    
    @objc dynamic open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let s = self.getSection(with: section)
        guard let configurationType = s.footerConfiguarationType else {return nil}
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: configurationType.identifier)
        
        if let view = view as? NKListSupplementaryViewConfigurable, let model = s.footerModel {
            view.listView(self, configWithModel: model, at: section)
        }
        
        return view
    }// custom view for footer. will be adjusted to default or
    
    @objc dynamic open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, accessoryButtonTappedForRowWith: indexPath)
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.tableView?(tableView, shouldHighlightRowAt: indexPath) ?? true
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, didHighlightRowAt: indexPath)
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, didUnhighlightRowAt: indexPath)
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return self.nk_delegate?.tableView?(tableView, willSelectRowAt: indexPath) ?? indexPath
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return self.nk_delegate?.tableView?(tableView, willDeselectRowAt: indexPath) ?? indexPath
    }
    
    // Called after the user changes the selection.
    @objc dynamic open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    // Editing
    
    // Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
    @objc dynamic open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return self.nk_delegate?.tableView?(tableView, editingStyleForRowAt: indexPath) ?? .none
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return self.nk_delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath) ?? nil
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return self.nk_delegate?.tableView?(tableView, editActionsForRowAt: indexPath) ?? nil
    }// supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
    
    
    // Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
    @objc dynamic open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.tableView?(tableView, shouldIndentWhileEditingRowAt: indexPath) ?? false
    }
    
    // The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
    @objc dynamic open func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.nk_delegate?.tableView?(tableView, willBeginEditingRowAt: indexPath)
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.nk_delegate?.tableView?(tableView, didEndEditingRowAt: indexPath)
    }
    
    
    // Moving/reordering
    
    // Allows customization of the target row for a particular row as it is being moved/reordered
    @objc dynamic open func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return self.nk_delegate?.tableView?(tableView, targetIndexPathForMoveFromRowAt: sourceIndexPath, toProposedIndexPath: proposedDestinationIndexPath) ?? proposedDestinationIndexPath
    }
    
    // Indentation
    @objc dynamic open func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return self.nk_delegate?.tableView?(tableView, indentationLevelForRowAt: indexPath) ?? 0
        //NPN TODO: check this
    }// return 'depth' of row for hierarchies
    
    @objc dynamic open func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.tableView?(tableView, shouldShowMenuForRowAt: indexPath) ?? false
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return self.nk_delegate?.tableView?(tableView, canPerformAction: action, forRowAt: indexPath, withSender: sender) ?? false
    }
    
    @objc dynamic open func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        self.nk_delegate?.tableView?(tableView, performAction: action, forRowAt: indexPath, withSender: sender)
    }
    
    // Focus
    @objc dynamic open func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return self.nk_delegate?.tableView?(tableView, canFocusRowAt: indexPath) ?? false
    }
    
    @available(iOS 9.0, *)
    @objc dynamic open func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return self.nk_delegate?.tableView?(tableView, shouldUpdateFocusIn: context) ?? false
    }
    
    @available(iOS 9.0, *)
    @objc dynamic open func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        self.nk_delegate?.tableView?(tableView, didUpdateFocusIn: context, with: coordinator)
    }
    
    @objc dynamic open func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return self.nk_delegate?.indexPathForPreferredFocusedView?(in: tableView) ?? nil
    }
    
    @objc dynamic open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidScroll?(scrollView)
        
        if let config = self.infinityConfig {
            let offset = scrollView.contentOffset
            let itemCount = max(1, (self.sections.first?.models.count ?? 0))
            let cellsHeight = Int(config.cellHeight) * itemCount
            let delta = offset.y - CGFloat(cellsHeight + Int(config.itemMargin) * (itemCount - 1))
            if delta > 0 {
                scrollView.contentOffset = CGPoint.init(x: offset.x, y: delta )
            }
        }
    }// any offset changes
    
    @objc dynamic open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidZoom?(scrollView)
    }// any zoom scale changes
    
    
    // called on start of dragging (may require some time and or distance to move)
    @objc dynamic open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
    @objc dynamic open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.nk_delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    @objc dynamic open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.nk_delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    @objc dynamic open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }// called on finger up as we are moving
    
    @objc dynamic open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidEndDecelerating?(scrollView)
    }// called when scroll view grinds to a halt
    
    @objc dynamic open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.nk_delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    
    @objc dynamic open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.nk_delegate?.viewForZooming?(in: scrollView) ?? nil
    }// return a view that will be scaled. if delegate returns nil, nothing happens
    
    @objc dynamic open func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.nk_delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }// called before the scroll view begins zooming its content
    
    @objc dynamic open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.nk_delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }// scale between minimum and maximum. called after any 'bounce' animations
    
    @objc dynamic open func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return self.nk_delegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }// return a yes if you want to scroll to the top. if not defined, assumes YES
    
    @objc dynamic open func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
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
//    @objc dynamic open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
//    @objc dynamic open func reloadWithItems(items: [Any]) {
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
        
        self.nk_scrollViewDidEndScrollingObservable
            .takeUntil(self.rx_paging.asObservable().filter({$0 == false}))
            .nk_observeAsyncOnMainQueue()
            .bindNext { [unowned self] (point) in
                //NPN TODO: recheck
                let itemSize = self.rowHeight
                let spacing: CGFloat = 0
                let inset = self.contentInset.top
                let viewSize = self.nk_height
                let value = itemSize + spacing
                let firstValue = 3 * itemSize / 2 + spacing + inset - viewSize / 2
                
                let sOffset = startedOffset?.y ?? 0
                let offset = point.y
                
                let currentPage: Int
                if offset >= firstValue {
                    currentPage = Int((offset - firstValue) / value) + 1
                } else {
                    currentPage = 0
                }
                
                let k = offset > sOffset ? 1 : 0
                
                let page = currentPage + k
                
                self.setCurrentPage(page)
            }.addDisposableTo(self.nk_disposeBag)
    }
}

