//
//  NKTableHeaderFooterView.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/9/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

open class NKTableHeaderFooterView: UITableViewHeaderFooterView {
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupRx()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
        self.setupRx()
    }
    
    dynamic open func setupView() {}
    dynamic open func setupRx() {}
}
