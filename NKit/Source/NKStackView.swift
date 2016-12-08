//
//  NKStackView.swift
//  NKit
//
//  Created by Nghia Nguyen on 12/8/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
public class NKStackView: UIStackView {
    override public var backgroundColor: UIColor? {
        get { return self.backgroundLayer.fillColor.flatMap({UIColor(CGColor: $0)}) }
        set {self.backgroundLayer.fillColor = newValue?.CGColor}
    }
    
    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, atIndex: 0)
        layer.fillColor = UIColor.clearColor().CGColor
        return layer
    }()
    
    private var preRect: CGRect?
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if self.bounds != self.preRect {
            backgroundLayer.path = UIBezierPath.init(rect: self.bounds).CGPath
            self.preRect = self.bounds
        }
    }
}
