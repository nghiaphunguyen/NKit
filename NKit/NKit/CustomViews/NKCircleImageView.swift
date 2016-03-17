//
//
//  Created by Nghia Nguyen on 2/20/16.
//

import UIKit

public class NKCircleImageView: NKBaseView {
    struct Constants {
        static let padding: CGFloat = 1
    }
    
    //MARK: Properties
    public var circleLineWidth: CGFloat {
        get {
            return self.circleView.circleLineWidth
        }
        
        set {
            self.circleView.circleLineWidth = newValue
        }
    }
    
    public var circleColor: UIColor {
        get {
            return self.circleView.circleColor
        }
        
        set {
            self.circleView.circleColor = newValue
        }
    }
    
    public lazy var circleView = NKCircleView(frame: CGRect.zero)
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public override func setupView() {
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        
        self.imageView.backgroundColor = UIColor.clearColor()
        self.addSubview(self.imageView)
        
        self.circleView.backgroundColor = UIColor.clearColor()
        self.addSubview(self.circleView)
        
        self.imageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0).offset(Constants.padding)
            make.leading.equalTo(0).offset(Constants.padding)
            make.trailing.equalTo(0).offset(-Constants.padding)
            make.bottom.equalTo(0).offset(-Constants.padding)
        }
        
        self.circleView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let width = rect.size.width / 2 - Constants.padding
        self.imageView.layer.cornerRadius = width
    }
}

public class NKCircleView : UIView {
    public lazy var circleLineWidth: CGFloat = 3
    public lazy var circleColor = UIColor.whiteColor()
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, self.circleLineWidth)
        CGContextSetStrokeColorWithColor(context, self.circleColor.CGColor)
        CGContextAddEllipseInRect(context, rect.insetBy(dx: self.circleLineWidth / 2, dy: self.circleLineWidth / 2))
        CGContextStrokePath(context)
    }
}
