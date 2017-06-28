//
//  NKLayoutTester.swift
//  InjectionTesting
//
//  Created by Nghia Nguyen on 9/24/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

open class NKLayoutTester: UIResponder {
    open func injected() {
        if let delegate = self as? UIApplicationDelegate,
            let window = delegate.window {
            window?.rootViewController = self._rootViewController
        }
    }
    
    open var testingLayout: NKLayoutTestable.Type? {
        return nil
    }
    
    open var rootViewController: UIViewController? {
        return nil
    }
    
    // can modify if need (not recommend)
    open var _rootViewController: UIViewController? {
        #if DEBUG
            if let testingLayout = self.testingLayout {
                return testingLayout.viewController
            }
        #endif
        
        return self.rootViewController
    }
}
