//
//  UIView+Utilities.swift
//
//  Created by Nghia Nguyen on 12/7/15.
//

import UIKit
import RxSwift

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

public extension UIView {
    public func nk_autoHideKeyboardWhenTapOutside() {
        self.rx_tap()
            .bindNext({[unowned self]_ in
                self.endEditing(true)})
            .addDisposableTo(self.nk_disposeBag)
    }
    
    public var nk_firstSubviewResponse: UIView? {
        if self.isFirstResponder() {
            return self
        }
        
        for view in self.subviews {
            if let v = view.nk_firstSubviewResponse {
                return v
            }
        }
        
        return nil
    }
    
    public func nk_findAllSubviews(types types: [AnyClass]) -> [UIView] {
        var result = [UIView]()
        
        if types.contains({self.isKindOfClass($0) })  {
            result += [self]
        }
        
        for view in self.subviews {
            result += view.nk_findAllSubviews(types: types)
        }
        return result
    }
}