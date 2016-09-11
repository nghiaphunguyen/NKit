//
//  NKTransition.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/11/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public final class NKAnimator: NSObject {
    
    public struct Animator {
        let context: UIViewControllerContextTransitioning
        let containerView: UIView
        let fromView: UIView
        let toView: UIView
        let fromViewController: UIViewController
        let toViewController: UIViewController
        let duration: NSTimeInterval
        
        public func completeTransition(didComplete: Bool? = nil) {
            if let didComplete = didComplete {
                self.context.completeTransition(didComplete)
            } else {
                self.context.completeTransition(!self.context.transitionWasCancelled())
            }
        }
    }
    
    public private(set) var duration: NSTimeInterval
    public private(set) var animations: (animator: Animator) -> Void
    
    public init(duration: NSTimeInterval, animations: (animator: Animator) -> Void) {
        self.duration = duration
        self.animations = animations
    }
}

extension NKAnimator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard transitionContext.isAnimated() else {
            return
        }
        
        guard let containerView = transitionContext.containerView(), toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey), fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) else {
            return
        }
        
        containerView.addSubview(toViewController.view)
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        
        self.animations(animator: Animator(context: transitionContext, containerView: containerView, fromView: fromViewController.view, toView: toViewController.view, fromViewController: fromViewController, toViewController: toViewController, duration: self.transitionDuration(transitionContext)))
    }
}


