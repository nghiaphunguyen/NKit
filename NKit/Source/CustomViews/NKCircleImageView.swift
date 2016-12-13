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
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        
        self.imageView.backgroundColor = UIColor.clear
        self.addSubview(self.imageView)
        
        self.circleView.backgroundColor = UIColor.clear
        self.addSubview(self.circleView)
        
        self.imageView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(1)
            make.leading.equalToSuperview().offset(1)
            make.trailing.equalToSuperview().offset(-1)
            make.bottom.equalToSuperview().offset(-1)
        }
        
        self.circleView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.enableCircle {
            let width = rect.size.width / 2 - 1
            self.imageView.layer.cornerRadius = width
        }
    }
}

class NKCircleView : UIView {
    lazy var circleLineWidth: CGFloat = 0
    lazy var circleColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setLineWidth(self.circleLineWidth)
        context.setStrokeColor(self.circleColor.cgColor)
        context.addEllipse(in: rect.insetBy(dx: self.circleLineWidth / 2, dy: self.circleLineWidth / 2))
        context.strokePath()
    }
}
