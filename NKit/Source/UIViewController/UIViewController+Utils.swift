//
//  UIViewController+Utils.swift
//  NKit
//
//  Created by Nghia Nguyen on 6/28/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit


extension UIViewController {
    var nk_visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.nk_visibleViewController
        }
        
        if let tabViewController = self as? UITabBarController {
            return tabViewController.selectedViewController?.nk_visibleViewController
        }
        
        return self
    }
    
    var nk_topViewController: UIViewController? {
        var viewController: UIViewController? = self
        while viewController?.presentedViewController != nil {
            viewController = viewController?.presentedViewController
        }
        
        return viewController
    }
    
    var nk_topVisibleViewController: UIViewController? {
        return self.nk_topViewController?.nk_visibleViewController
    }
}