//
//  NKTableView.swift
//  NKit
//
//  Created by Nghia Nguyen on 4/17/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import Foundation
import SnapKit

//MARK: - Constants
private extension NKTableView {
    struct Constant {
        static var EstimatedRowHeight: CGFloat {return 100}
    }
}

//MARK: Properties
public class NKTableView: UITableView {
    public var selectedCell: ((indexPath: NSIndexPath, cellModel: Any))?
    public var items: (() -> [[Any]])?
    
    public var isHeightToFit = false {
        didSet {
            self.estimatedRowHeight = Constant.EstimatedRowHeight
            self.rowHeight = UITableViewAutomaticDimension
            self.setNeedsLayout()
        }
    }
    
    //private properties
    private lazy var preHeight: CGFloat? = nil
    
    //Constructor
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
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

//MARK: - Setup view
private extension NKTableView {
    private func setupView() {
        
    }
}

//MARK: - UITableViewDataSource
extension NKTableView: UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension NKTableView: UITableViewDelegate {
    
}
 