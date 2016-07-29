//
//  NKCornerView.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/12/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit

class NKCornerView: UIView {
    
    private var rectCorner: UIRectCorner = .AllCorners
    private var radius: CGFloat = 0
    
    init(frame: CGRect = CGRectZero, rectCorner: UIRectCorner,
         radius: CGFloat) {
        super.init(frame: frame)
        self.contentMode = .Redraw
        self.rectCorner = rectCorner
        self.radius = radius
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: rectCorner,
                                cornerRadii: CGSizeMake(self.radius, self.radius))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = rect
        shapeLayer.path = path.CGPath
        
        self.layer.mask = shapeLayer
    }
}