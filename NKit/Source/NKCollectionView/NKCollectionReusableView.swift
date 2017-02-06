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
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open func setupView() {}
}
