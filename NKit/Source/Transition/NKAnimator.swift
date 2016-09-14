//
//  NKTransition.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/11/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public final class NKAnimator: NSObject {
    
    public enum AnimationType {
        case Default
        case Interactive
        case Both
    }
    
    public enum TransitionType {
        case Push
        case Pop
        case Present
        case Dismiss
    }
    
    public struct Context {
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
    
    public private(set) var animationType: AnimationType
    public private(set) var duration: NSTimeInterval
    public private(set) var animations: (context: Context) -> Void
    public private(set) var transitionType: TransitionType
    public private(set) var interactive: UIPercentDrivenInteractiveTransition? = nil
    public private(set) var isInteracting = false
    
    public init(duration: NSTimeInterval,
                transitionType: TransitionType,
                animationType: AnimationType = .Both,
                animations: (context: Context) -> Void) {
        self.duration = duration
        self.animations = animations
        self.transitionType = transitionType
        self.animationType = animationType
    }
    
    public static func present(duration duration: NSTimeInterval, animationType: AnimationType = .Both, animations: (context: Context) -> Void) -> NKAnimator {
        return NKAnimator(duration: duration, transitionType: .Present, animationType: animationType, animations: animations)
    }
    
    public static func dismiss(duration duration: NSTimeInterval, animationType: AnimationType = .Both, animations: (context: Context) -> Void) -> NKAnimator {
        return NKAnimator(duration: duration, transitionType: .Dismiss, animationType: animationType, animations: animations)
    }
    
    public static func push(duration duration: NSTimeInterval, animationType: AnimationType = .Both, animations: (context: Context) -> Void) -> NKAnimator {
        return NKAnimator(duration: duration, transitionType: .Push, animationType: animationType, animations: animations)
    }
    
    public static func pop(duration duration: NSTimeInterval, animationType: AnimationType = .Both, animations: (context: Context) -> Void) -> NKAnimator {
        return NKAnimator(duration: duration, transitionType: .Pop, animationType: animationType, animations: animations)
    }
    
    public func clone() -> NKAnimator {
        return NKAnimator(duration: duration, transitionType: transitionType, animationType: animationType, animations: animations)
    }
    
    public func changeTransitionType(type: TransitionType) -> Self {
        self.transitionType = type
        return self
    }
    
    public func changeAnimationType(type: AnimationType) -> Self {
        self.animationType = type
        return self
    }
    
    public func changeDuration(duration: NSTimeInterval) -> Self {
        self.duration = duration
        return self
    }
    
    public func startInteractiveTransition() {
        self.interactive = UIPercentDrivenInteractiveTransition()
        self.isInteracting = true
    }
    
    public func finishInteractiveTransition() {
        self.interactive?.finishInteractiveTransition()
        self.interactive = nil
        self.isInteracting = false
    }
    
    public func cancelInteractiveTransition() {
        self.interactive?.cancelInteractiveTransition()
        self.interactive = nil
        self.isInteracting = false
    }
    
    public func updateInteractiveTransition(percentComplete: CGFloat) {
        self.interactive?.updateInteractiveTransition(percentComplete)
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
        
        let addToViewControllerClosure = {
            containerView.addSubview(toViewController.view)
            toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        }
        
        switch self.transitionType {
        case .Push, .Present:
            addToViewControllerClosure()
        case .Pop:
            addToViewControllerClosure()
            containerView.bringSubviewToFront(fromViewController.view)
        case .Dismiss:
            if fromViewController.modalPresentationStyle != .Custom {
                addToViewControllerClosure()
                containerView.bringSubviewToFront(fromViewController.view)
            }
        }
        
        self.animations(context: Context(context: transitionContext, containerView: containerView, fromView: fromViewController.view, toView: toViewController.view, fromViewController: fromViewController, toViewController: toViewController, duration: self.transitionDuration(transitionContext)))
    }
}


