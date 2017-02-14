//
//  NKCollectionReusableView.swift
//  IgListKitExample
//
//  Created by Nghia Nguyen on 1/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

open class NKCollectionReusableView: UICollectionReusableView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
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
