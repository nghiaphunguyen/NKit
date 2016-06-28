//
//  NKTableViewCell.swift
//  NKit
//
//  Created by Nghia Nguyen on 4/17/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit

public class NKBaseTableViewCell: UITableViewCell {
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    public func setupView() {}
}