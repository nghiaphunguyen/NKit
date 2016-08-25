//
//  UIView+Utilities.swift
//
//  Created by Nghia Nguyen on 12/7/15.
//

import UIKit

public extension UIView {
    public var nk_parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.nextResponder()
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
    
    public func nk_addBorder(borderWidth borderWidth: CGFloat = 1,
        color: UIColor = UIColor.blackColor(),
        cornerRadius: CGFloat = 0) -> UIView {
            self.layer.borderColor = color.CGColor
            self.layer.borderWidth = borderWidth
            
            self.layer.cornerRadius = cornerRadius
            
            self.clipsToBounds = true
            
            return self
    }
    
    public func nk_addAllBorderToSubview() -> UIView {
        for view in self.subviews {
            view.nk_addBorder(borderWidth: 1, color: UIColor.yellowColor())
            view.nk_addAllBorderToSubview()
        }
        
        self.nk_addBorder(borderWidth: 1, color: UIColor.yellowColor())
        
        return self
    }
    
    public func nk_snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.mainScreen().scale)
        
        let context = UIGraphicsGetCurrentContext()
        self.layer.renderInContext(context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }
}
