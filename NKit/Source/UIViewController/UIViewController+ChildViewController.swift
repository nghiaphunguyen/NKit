//
//  UIViewController+ChildViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 6/28/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit
public extension UIViewController {
    @objc public func nk_addChildViewController(controller: UIViewController) {
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
    
    @objc public func nk_removeFromParentViewController() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}


public extension UIViewController {
    @objc public func nk_hideKeyboardWhenTappedOuside() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.nk_hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc public func nk_hideKeyboard() {
        self.view.endEditing(true)
    }
}
