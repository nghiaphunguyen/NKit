//
//  UIViewController+Injection.swift
//  Fossil
//
//  Created by Nghia Nguyen on 3/18/16.
//

import UIKit

//HOW TO USE INJECTION
//1. Install "InjectionPlugin" via Alcatraz(http://alcatraz.io/) (reset xcode to apply)
//2. Optional - Override func setupInjection: to setup injection
//3. Run injection - Ctrl+=

public extension UIViewController {
    public func injected() {
        
        let viewController: UIViewController
        if let storyboard = self.storyboard, restorationIdentifier = self.restorationIdentifier {
            viewController = storyboard.instantiateViewControllerWithIdentifier(restorationIdentifier)
        } else {
            viewController = self.dynamicType.self.init()
        }
        
        viewController.setupInjection(oldViewController: self)
        
        if let navigationController = self.navigationController {
            
            if self == navigationController.viewControllers.first {
                navigationController.setViewControllers([viewController], animated: false)
            } else {
                navigationController.popViewControllerAnimated(false)
                navigationController.pushViewController(viewController, animated: false)
            }
        } else {
            let presentingViewController = self.presentingViewController
            if let presentingViewController = presentingViewController {
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    presentingViewController.presentViewController(viewController, animated: false, completion: nil)
                })
            } else {
                UIApplication.sharedApplication().delegate?.window?.map({$0.rootViewController = viewController})
            }
        }
    }
    
    //NPN: Override this func to inject some function
    public func setupInjection(oldViewController oldViewController: UIViewController) {}
}
