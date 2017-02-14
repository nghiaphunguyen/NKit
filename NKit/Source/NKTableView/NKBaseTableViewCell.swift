//
//  NKTableViewCell.swift
//  NKit
//
//  Created by Nghia Nguyen on 4/17/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit

open class NKBaseTableViewCell: UITableViewCell {
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupRx()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
        self.setupRx()
    }
    
    open func setupView() {}
    
    open func setupRx() {}
}
