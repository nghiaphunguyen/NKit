//
//  NKGradientView.swift
//
//  Created by Nghia Nguyen on 2/23/16.
//

import UIKit


public class NKGradientView: UIView {
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        self.layer.insertSublayer(layer, atIndex: 0)
        return layer
    }()
    
    private var cgColors = [CGColor]()
    
    public var colors = [UIColor]() {
        didSet {
            cgColors.removeAll()
            for color in self.colors {
                cgColors.append(color.CGColor)
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.gradientLayer.frame = rect
        self.gradientLayer.colors = self.cgColors
    }
    
}