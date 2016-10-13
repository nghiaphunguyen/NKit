//
//  UIView+Utilities.swift
//
//  Created by Nghia Nguyen on 12/7/15.
//

import UIKit
import RxSwift
import RxCocoa

public extension UIView {
    public var nk_parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
    
    public func nk_addBorder(borderWidth: CGFloat = 1,
        color: UIColor = UIColor.black,
        cornerRadius: CGFloat = 0) -> UIView {
            self.layer.borderColor = color.cgColor
            self.layer.borderWidth = borderWidth
            
            self.layer.cornerRadius = cornerRadius
            
            self.clipsToBounds = true
            
            return self
    }
    
    public func nk_addAllBorderToSubview() -> UIView {
        for view in self.subviews {
            view.nk_addBorder(borderWidth: 1, color: UIColor.yellow)
            view.nk_addAllBorderToSubview()
        }
        
        self.nk_addBorder(borderWidth: 1, color: UIColor.yellow)
        
        return self
    }
    
    public func nk_snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image!
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
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let v = view.nk_firstSubviewResponse {
                return v
            }
        }
        
        return nil
    }
    
    public func nk_findAllSubviews(types: [AnyClass]) -> [UIView] {
        var result = [UIView]()
        
        if types.contains(where: {self.isKind(of: $0) })  {
            result += [self]
        }
        
        for view in self.subviews {
            result += view.nk_findAllSubviews(types: types)
        }
        return result
    }
}
