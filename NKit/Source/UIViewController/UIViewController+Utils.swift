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
    
    public var nk_sourceViewController: UIViewController? {
        return self.presentingViewController?._nk_sourceViewControllerFromViewController(self)
    }
    
    private func _nk_sourceViewControllerFromViewController(viewController: UIViewController) -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            for i in (navigationController.viewControllers.count-1).stride(to: 0, by: -1) {
                if let sourceViewController = navigationController.viewControllers[i]._nk_sourceViewControllerFromViewController(viewController) {
                    return sourceViewController
                }
            }
        }
        
        if let tabController = self as? UITabBarController, viewControllers = tabController.viewControllers {
            for i in (viewControllers.count-1).stride(to: 0, by: -1) {
                if let sourceViewController = viewControllers[i]._nk_sourceViewControllerFromViewController(viewController) {
                    return sourceViewController
                }
            }
        }
        
        if self.presentedViewController == viewController {
            return self
        }
        
        return nil
    }
}

private struct Identifier {
    static var GestureRecognizerDelegate: UInt8 = 1
}

extension UIViewController{
        
    var nk_gestureRecognizerDelegate: NKGestureRecognizerDelegate? {
        get {
            return objc_getAssociatedObject(self, &Identifier.GestureRecognizerDelegate) as? NKGestureRecognizerDelegate
        }
        
        set {
            objc_setAssociatedObject(self, &Identifier.GestureRecognizerDelegate, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

