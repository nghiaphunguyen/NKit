//
//  UIViewController+Analytics.swift
//  NKit
//
//  Created by Nghia Nguyen on 12/14/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

//protocol NKScreenTrackable {
//    func trackingNames() -> [String]
//}

//public extension UIViewController {
//    override open class func initialize() {
//
//        // make sure this isn't a subclass
//        if self !== UIViewController.self {
//            return
//        }
//
//            let originalSelector = #selector(UIViewController.viewDidLoad)
//            let swizzledSelector = #selector(UIViewController.analytics_viewDidLoad)
//
//            let originalMethod = class_getInstanceMethod(self, originalSelector)
//            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
//
//            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
//
//            if didAddMethod {
//                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
//            } else {
//                method_exchangeImplementations(originalMethod, swizzledMethod);
//            }
//    }
//
//    // MARK: - Method Swizzling
//
//    func analytics_viewDidLoad() {
//        self.analytics_viewDidLoad()
//
//        guard let analyzable = self as? NKScreenTrackable else {
//            return
//        }
//
//        analyzable.trackingNames().forEach({
//            NKEVENT.log(name: $0, type: NKEventType.screen, extraInfo: nil)
//        })
//    }
//}
