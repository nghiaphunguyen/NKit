//
//  NKNavigationTransition.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/13/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public final class NKPresentationTransition: NSObject {
    public private(set) var presentAnimator: NKAnimator? = nil
    public private(set) var dismissAnimator: NKAnimator? = nil
    public private(set) var controller: UIPresentationController? = nil
    
    public init(presentAnimator: NKAnimator? = nil, dismissAnimator: NKAnimator?, controller: UIPresentationController?) {
        self.presentAnimator = presentAnimator
        self.dismissAnimator = dismissAnimator
        self.controller = controller
    }
    
    public override init() {
        super.init()
    }
    
    public func changePresentAniamtor(animator: NKAnimator?) -> Self {
        self.presentAnimator = animator
        return self
    }
    
    public func changeDismissAniamator(animator: NKAnimator?) -> Self {
        self.dismissAnimator = animator
        return self
    }
    
    public func changeController(controller: UIPresentationController?) -> Self {
        self.controller = controller
        return self
    }
}

extension NKPresentationTransition: UIViewControllerTransitioningDelegate {
    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        self.controller?.setValue(presented, forKey: "presentedViewController")
        self.controller?.setValue(presenting, forKey: "presentingViewController")
        return controller
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let animator = self.presentAnimator else {
            return nil
        }
        
        switch animator.animationType {
        case .Both:
            return animator
        case .Default:
            if animator.isInteracting {
                return nil
            }
            
            return animator
        case .Interactive:
            if animator.isInteracting {
                return animator
            }
            
            return nil
        }
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let animator = self.dismissAnimator else {
            return nil
        }
        
        switch animator.animationType {
        case .Both:
            return animator
        case .Default:
            if animator.isInteracting {
                return nil
            }
            
            return animator
        case .Interactive:
            if animator.isInteracting {
                return animator
            }
            
            return nil
        }
    }
    
    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        guard let animator = self.presentAnimator else {
            return nil
        }
        
        switch animator.animationType {
        case .Both, .Interactive:
            return animator.interactive
        case .Default:
            return nil
        }
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = self.dismissAnimator else {
            return nil
        }
        
        switch animator.animationType {
        case .Both, .Interactive:
            return animator.interactive
        case .Default:
            return nil
        }
    }
}