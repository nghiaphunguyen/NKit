//
//  ProfilePictureImageView.swift
//  FastSell
//
//  Created by Nghia Nguyen on 2/20/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import UIKit

class NKCircleImageView: UIView {
    lazy var circleView = NKCircleView(frame: CGRect.zero)
    
    lazy var enableCircle = true
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        
        self.imageView.backgroundColor = UIColor.clearColor()
        self.addSubview(self.imageView)
        
        self.circleView.backgroundColor = UIColor.clearColor()
        self.addSubview(self.circleView)
        
        self.imageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0).offset(1)
            make.leading.equalTo(0).offset(1)
            make.trailing.equalTo(0).offset(-1)
            make.bottom.equalTo(0).offset(-1)
        }
        
        self.circleView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if self.enableCircle {
            let width = rect.size.width / 2 - 1
            self.imageView.layer.cornerRadius = width
        }
    }
}

class NKCircleView : UIView {
    lazy var circleLineWidth: CGFloat = 0
    lazy var circleColor = UIColor.whiteColor()
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, self.circleLineWidth)
        CGContextSetStrokeColorWithColor(context, self.circleColor.CGColor)
        CGContextAddEllipseInRect(context, rect.insetBy(dx: self.circleLineWidth / 2, dy: self.circleLineWidth / 2))
        CGContextStrokePath(context)
    }
}