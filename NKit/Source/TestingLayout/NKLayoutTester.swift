//
//  NKLayoutTester.swift
//  InjectionTesting
//
//  Created by Nghia Nguyen on 9/24/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public class NKLayoutTester: UIResponder {
    public func injected() {
        if let delegate = self as? UIApplicationDelegate,
            let window = delegate.window {
            window?.rootViewController = self._rootViewController
        }
    }
    
    public var testingLayout: NKLayoutTestable.Type? {
        return nil
    }
    
    public var rootViewController: UIViewController? {
        return nil
    }
    
    public final var _rootViewController: UIViewController? {
        #if DEBUG
            if let testingLayout = self.testingLayout {
                return testingLayout.viewController
            }
        #endif
        
        return self.rootViewController
    }
}
