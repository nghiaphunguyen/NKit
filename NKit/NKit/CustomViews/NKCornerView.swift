//
//  NKCornerView.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/12/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit

public class NKCornerView<T: UIView>: NKContainerView<T> {
    private var rectCorner: UIRectCorner?
    private var cornerRadius: CGFloat = 0
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        guard let rectCorner = self.rectCorner else {
            return
        }
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: rectCorner,
            cornerRadii: CGSizeMake(self.cornerRadius, self.cornerRadius))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = rect
        shapeLayer.path = path.CGPath
        
        self.layer.mask = shapeLayer
    }
}
