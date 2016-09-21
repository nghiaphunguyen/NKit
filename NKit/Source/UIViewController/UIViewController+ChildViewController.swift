//
//  UIViewController+ChildViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 6/28/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit

public extension UIViewController {
    public func nk_addChildViewController(controller: UIViewController, frame: CGRect) {
        self.addChildViewController(controller)
        controller.view.frame = frame
        self.view.addSubview(controller.view)
        
        controller.didMoveToParentViewController(self)
    }
    
    public func nk_addChildViewController(controller: UIViewController) {
        self.nk_addChildViewController(controller, frame: self.view.bounds)
    }
    
    public func nk_removeFromParentViewController() {
        self.willMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}


public extension UIViewController {
    public func nk_hideKeyboardWhenTappedOuside() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dynamicType.nk_hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    public func nk_hideKeyboard() {
        self.view.endEditing(true)
    }
}