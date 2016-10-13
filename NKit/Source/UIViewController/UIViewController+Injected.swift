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
        if let storyboard = self.storyboard, let restorationIdentifier = self.restorationIdentifier {
            viewController = storyboard.instantiateViewController(withIdentifier: restorationIdentifier)
        } else {
            viewController = type(of: self).init()
        }
        
        viewController.setupInjection(oldViewController: self)
        
        if let navigationController = self.navigationController {
            
            if self == navigationController.viewControllers.first {
                navigationController.setViewControllers([viewController], animated: false)
            } else {
                navigationController.popViewController(animated: false)
                navigationController
                    .pushViewController(viewController, animated: false)
            }
        } else {
            let presentingViewController = self.presentingViewController
            if let presentingViewController = presentingViewController {
                self.dismiss(animated: false, completion: { () -> Void in
                    presentingViewController.present(viewController, animated: false, completion: nil)
                })
            } else {
                UIApplication.shared.delegate?.window?.map({$0.rootViewController = viewController})
            }
        }
    }
    
    //NPN: Override this func to inject some function
    public func setupInjection(oldViewController: UIViewController) {}
}
