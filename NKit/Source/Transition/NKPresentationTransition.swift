//
//  NKNavigationTransition.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/13/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public final class NKPresentationTransition: NSObject {
    open private(set) var presentAnimator: NKAnimator? = nil
    open private(set) var dismissAnimator: NKAnimator? = nil
    open private(set) var controller: UIPresentationController? = nil
    
    public init(presentAnimator: NKAnimator? = nil, dismissAnimator: NKAnimator?, controller: UIPresentationController?) {
        self.presentAnimator = presentAnimator
        self.dismissAnimator = dismissAnimator
        self.controller = controller
    }
    
    public override init() {
        super.init()
    }
    
    open func changePresentAniamtor(animator: NKAnimator?) -> Self {
        self.presentAnimator = animator
        return self
    }
    
    open func changeDismissAniamator(animator: NKAnimator?) -> Self {
        self.dismissAnimator = animator
        return self
    }
    
    open func changeController(controller: UIPresentationController?) -> Self {
        self.controller = controller
        return self
    }
}

extension NKPresentationTransition: UIViewControllerTransitioningDelegate {
    
    dynamic open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        self.controller?.setValue(presented, forKey: "presentedViewController")
        self.controller?.setValue(presenting, forKey: "presentingViewController")
        return controller
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
    
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
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
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
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
}
