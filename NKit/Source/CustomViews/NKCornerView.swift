//
//  NKCornerView.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/12/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit

public class NKCornerView: UIView {
    
    public var rectCorner: UIRectCorner = .allCorners {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    public var radius: CGFloat = 0 {
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
    
    public override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: rectCorner,
                                cornerRadii: CGSize(width: self.radius, height: self.radius))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = rect
        shapeLayer.path = path.cgPath
        
        self.layer.mask = shapeLayer
    }
}
