//
//  NKBaseView.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 3/16/16.
//  Copyright © 2016 misfit. All rights reserved.
//

import UIKit

public class NKBaseView: UIView {
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
    
    public func setupView() {
    }
    
    public func setupRx() {
    }
}
