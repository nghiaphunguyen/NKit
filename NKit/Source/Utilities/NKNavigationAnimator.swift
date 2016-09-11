//
//  NKNavigationAnimator.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/12/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import UIKit

public final class NKNavigationAnimator: NSObject {
    public var pushAnimator: UIViewControllerAnimatedTransitioning? = nil
    public var popAnimator: UIViewControllerAnimatedTransitioning? = nil
    
    public var popInteractiveAnimator: UIPercentDrivenInteractiveTransition? = nil
    public var pushInteractiveAnimator: UIPercentDrivenInteractiveTransition? = nil
    
    public private(set) var type: UIViewController.Type
    
    public init(type: UIViewController.Type) {
        self.type = type
    }
}

extension NKNavigationAnimator: UINavigationControllerDelegate {
    public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController === self.popInteractiveAnimator {
            return self.popInteractiveAnimator
        }
        
        if animationController === self.pushInteractiveAnimator {
            return self.pushInteractiveAnimator
        }
        
        return nil
    }
    
    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard "\(fromVC.dynamicType)" == "\(type)" else {
            return nil
        }
        
        switch operation {
        case .Push:
            return self.pushAnimator
        case .Pop:
            return self.popAnimator
        default:
            return nil
        }
    }
}