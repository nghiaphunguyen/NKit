//
//  UIViewController+ChildViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 6/28/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit

extension UIViewController {
    func nk_addChildViewController(controller: UIViewController, frame: CGRect) {
        self.addChildViewController(controller)
        controller.view.frame = frame
        self.view.addSubview(controller.view)
        
        controller.didMoveToParentViewController(self)
    }
    
    func nk_addChildViewController(controller: UIViewController) {
        self.nk_addChildViewController(controller, frame: self.view.bounds)
    }
    
    func nk_removeFromParentViewController() {
        self.willMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}
