//
//  NKTableViewCell.swift
//  NKit
//
//  Created by Nghia Nguyen on 4/17/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit

open class NKBaseTableViewCell: UITableViewCell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupRx()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
        self.setupRx()
    }
    
    @objc dynamic open func setupView() {}
    
    @objc dynamic open func setupRx() {}
}
