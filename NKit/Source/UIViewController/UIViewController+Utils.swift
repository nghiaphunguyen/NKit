//
//  UIViewController+Utils.swift
//  NKit
//
//  Created by Nghia Nguyen on 6/28/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit


public extension UIViewController {
    public var nk_visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.nk_visibleViewController
        }
        
        if let tabViewController = self as? UITabBarController {
            return tabViewController.selectedViewController?.nk_visibleViewController
        }
        
        return self
    }
    
    public var nk_topViewController: UIViewController? {
        var viewController: UIViewController? = self
        while viewController?.presentedViewController != nil {
            viewController = viewController?.presentedViewController
        }
        
        return viewController
    }
    
    public var nk_topVisibleViewController: UIViewController? {
        return self.nk_topViewController?.nk_visibleViewController
    }
}

private var NKAssociatedGestureRecognizerDelegate: UInt8 = 0
extension UIViewController{
    
    var nk_gestureRecognizerDelegate: NKGestureRecognizerDelegate? {
        get {
            return objc_getAssociatedObject(self, &NKAssociatedGestureRecognizerDelegate) as? NKGestureRecognizerDelegate
        }
        
        set {
            objc_setAssociatedObject(self, &NKAssociatedGestureRecognizerDelegate, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


