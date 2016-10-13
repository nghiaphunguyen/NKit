//
//  NKGradientView.swift
//
//  Created by Nghia Nguyen on 2/23/16.
//

import UIKit


open class NKGradientView: UIView {
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    
    private var cgColors = [CGColor]()
    
    open var colors = [UIColor]() {
        didSet {
            cgColors.removeAll()
            for color in self.colors {
                cgColors.append(color.cgColor)
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.gradientLayer.frame = rect
        self.gradientLayer.colors = self.cgColors
    }
    
}
