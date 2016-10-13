//
//  NKCornerView.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/12/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit

open class NKCornerView: UIView {
    
    open var rectCorner: UIRectCorner = .allCorners {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    open var radius: CGFloat = 0 {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    public init(frame: CGRect = CGRect.zero, rectCorner: UIRectCorner,
         radius: CGFloat) {
        super.init(frame: frame)
        self.contentMode = .redraw
        self.rectCorner = rectCorner
        self.radius = radius
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: rectCorner,
                                cornerRadii: CGSize(width: self.radius, height: self.radius))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = rect
        shapeLayer.path = path.cgPath
        
        self.layer.mask = shapeLayer
    }
}
