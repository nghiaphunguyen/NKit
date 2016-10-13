//
//  NKTableView.swift
//  FastSell
//
//  Created by Nghia Nguyen on 4/18/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import Foundation
import NATTableView
import UIKit

//MARK: - Constants
private extension NKTableView {
    struct Constant {
        static var EstimatedRowHeight: CGFloat {return 50}
    }
}

//MARK: - Properties
open class NKTableView: ATTableView {
    
    //private properties
    
    lazy var preHeight: CGFloat? = nil
    
    open var cellHeightToFit = false {
        didSet {
            self.estimatedRowHeight = Constant.EstimatedRowHeight
            self.rowHeight = UITableViewAutomaticDimension
            self.setNeedsLayout()
        }
    }
    
    open var isHeightToFit = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open var addMoreConfigForCell: ((_ cell: UITableViewCell, _ indexPath: IndexPath) -> Void)?
    
    open var separateHeight: CGFloat? //just trick to use separate views
    
    open override func initialize() {
        super.initialize()
        
        if self.isHeightToFit {
            self.snp.updateConstraints({ (make) in
                make.height.equalTo(Constant.EstimatedRowHeight)
            })
        }
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        self.addMoreConfigForCell?(cell, indexPath)
        return cell
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.isHeightToFit && self.contentSize.height != self.preHeight{
            self.preHeight = self.contentSize.height
            
            self.snp.updateConstraints({ (make) -> Void in
                make.height.equalTo(self.contentSize.height)
            })
        }
        
        self.layoutIfNeeded()
    }
}

public extension NKTableView {
    public func reloadWithItems(items: [Any]) {
        self.clearAll()
        
        if let separateHeight = self.separateHeight {
            for (index, item) in items.enumerated() {
                let section = ATTableViewSection()
                section.headerHeight = separateHeight
                section.customHeaderView = { (_) in
                    let view = UIView()
                    view.backgroundColor = UIColor.clear
                    return view
                }
                self.addSection(section: section, atIndex: index)
                self.addItems(items: [item], section: index)
            }
        } else {
            self.addItems(items: items)
        }
        
        self.reloadData()
    }
}
