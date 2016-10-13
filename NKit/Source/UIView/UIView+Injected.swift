//
//  UIView+Injected.swift
//  InjectionTesting
//
//  Created by Nghia Nguyen on 9/23/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public extension UIView {
    public func injected() {
        guard let parentViewController = self.nk_parentViewController else {
            return
        }
        
        if type(of: parentViewController) == UIViewController.self {
            if let testable = self as? NKLayoutTestable, let window = UIApplication.shared.delegate?.window {
                window?.rootViewController = type(of: testable).viewController
            }
        } else {
            parentViewController.injected()
        }
    }
}
