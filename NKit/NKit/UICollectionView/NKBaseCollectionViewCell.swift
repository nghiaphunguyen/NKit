//
//  NKBaseCollectionViewCell.swift
//  FastSell
//
//  Created by Nghia Nguyen on 5/21/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import UIKit

public class NKBaseCollectionViewCell: UICollectionViewCell {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupView()
    }
    
    public func setupView() {}
}
