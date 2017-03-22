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
        public let context: UIViewControllerContextTransitioning
        public let containerView: UIView
        public let fromView: UIView
        public let toView: UIView
        public let fromViewController: UIViewController
        public let toViewController: UIViewController
        public let duration: TimeInterval
        
        public func completeTransition(didComplete: Bool? = nil) {
            if let didComplete = didComplete {
                self.context.completeTransition(didComplete)
            } else {
                self.context.completeTransition(!self.context.transitionWasCancelled)
            }
        }
    }
    
    open private(set) var animationType: AnimationType
    open private(set) var duration: TimeInterval
    open private(set) var animations: (_ context: Context) -> Void
    open private(set) var transitionType: TransitionType
    open private(set) var interactive: UIPercentDrivenInteractiveTransition? = nil
    open private(set) var isInteracting = false
    
    public init(duration: TimeInterval,
                transitionType: TransitionType,
                animationType: AnimationType = .Both,
                animations: @escaping (_ context: Context) -> Void) {
        self.duration = duration
        self.animations = animations
        self.transitionType = transitionType
        self.animationType = animationType
    }
    
    open static func present(duration: TimeInterval, animationType: AnimationType = .Both, animations: @escaping (_ context: Context) -> Void) -> NKAnimator {
        return NKAnimator(duration: duration, transitionType: .Present, animationType: animationType, animations: animations)
    }
    
    open static func dismiss(duration: TimeInterval, animationType: AnimationType = .Both, animations: @escaping (_ context: Context) -> Void) -> NKAnimator {
        return NKAnimator(duration: duration, transitionType: .Dismiss, animationType: animationType, animations: animations)
    }
    
    open static func push(duration: TimeInterval, animationType: AnimationType = .Both, animations: @escaping (_ context: Context) -> Void) -> NKAnimator {
        return NKAnimator(duration: duration, transitionType: .Push, animationType: animationType, animations: animations)
    }
    
    open static func pop(duration: TimeInterval, animationType: AnimationType = .Both, animations: @escaping (_ context: Context) -> Void) -> NKAnimator {
        return NKAnimator(duration: duration, transitionType: .Pop, animationType: animationType, animations: animations)
    }
    
    open func clone() -> NKAnimator {
        return NKAnimator(duration: duration, transitionType: transitionType, animationType: animationType, animations: animations)
    }
    
    open func changeTransitionType(type: TransitionType) -> Self {
        self.transitionType = type
        return self
    }
    
    open func changeAnimationType(type: AnimationType) -> Self {
        self.animationType = type
        return self
    }
    
    open func changeDuration(duration: TimeInterval) -> Self {
        self.duration = duration
        return self
    }
    
    open func startInteractiveTransition() {
        self.interactive = UIPercentDrivenInteractiveTransition()
        self.isInteracting = true
    }
    
    open func finishInteractiveTransition() {
        self.interactive?.finish()
        self.interactive = nil
        self.isInteracting = false
    }
    
    open func cancelInteractiveTransition() {
        self.interactive?.cancel()
        self.interactive = nil
        self.isInteracting = false
    }
    
    open func updateInteractiveTransition(percentComplete: CGFloat) {
        self.interactive?.update(percentComplete)
    }
}

extension NKAnimator: UIViewControllerAnimatedTransitioning {
    
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard transitionContext.isAnimated else {
            return
        }
        
        let containerView = transitionContext.containerView
        guard let toViewController = transitionContext.viewController(forKey: .to), let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        let addToViewControllerClosure = {
            containerView.addSubview(toViewController.view)
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        }
        
        switch self.transitionType {
        case .Push, .Present:
            addToViewControllerClosure()
        case .Pop:
            addToViewControllerClosure()
            containerView.bringSubview(toFront: fromViewController.view)
        case .Dismiss:
            if fromViewController.modalPresentationStyle != .custom {
                addToViewControllerClosure()
                containerView.bringSubview(toFront: fromViewController.view)
            }
        }
        
        self.animations(Context(context: transitionContext, containerView: containerView, fromView: fromViewController.view, toView: toViewController.view, fromViewController: fromViewController, toViewController: toViewController, duration: self.transitionDuration(using: transitionContext)))
    }
}


