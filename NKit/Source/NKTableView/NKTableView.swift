//
//  NKTableView.swift
//  FastSell
//
//  Created by Nghia Nguyen on 4/18/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import Foundation
import ATTableView
import UIKit

//MARK: - Constants
private extension NKTableView {
    struct Constant {
        static var EstimatedRowHeight: CGFloat {return 50}
    }
}

//MARK: - Properties
public class NKTableView: ATTableView {
    
    //private properties
    private lazy var preHeight: CGFloat? = nil
    
    public var cellHeightToFit = false {
        didSet {
            self.estimatedRowHeight = Constant.EstimatedRowHeight
            self.rowHeight = UITableViewAutomaticDimension
            self.setNeedsLayout()
        }
    }
    
    public var isHeightToFit = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var addMoreConfigForCell: ((cell: UITableViewCell, indexPath: NSIndexPath) -> Void)?
    
    public var separateHeight: CGFloat? //just trick to use separate views
    
    public override func initialize() {
        super.initialize()
        
        if self.isHeightToFit {
            self.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(Constant.EstimatedRowHeight)
            })
        }
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        self.addMoreConfigForCell?(cell: cell, indexPath: indexPath)
        return cell
    }
}

public extension NKTableView {
    public func reloadWithItems(items: [Any]) {
        self.clearAll()
        
        if let separateHeight = self.separateHeight {
            for (index, item) in items.enumerate() {
                let section = ATTableViewSection()
                section.headerHeight = separateHeight
                section.customHeaderView = { (_) in
                    let view = UIView()
                    view.backgroundColor = UIColor.clearColor()
                    return view
                }
                self.addSection(section, atIndex: index)
                self.addItems([item], section: index)
            }
        } else {
            self.addItems(items)
        }
        
        self.reloadData()
    }
}

//MARK: - Override functions
public extension NKTableView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.isHeightToFit && self.contentSize.height != self.preHeight{
            self.preHeight = self.contentSize.height
            
            self.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(self.contentSize.height)
            })
        }
        
        self.layoutIfNeeded()
    }
}