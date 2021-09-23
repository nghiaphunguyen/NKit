//
//  NKNavigationTransition.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/13/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public final class NKNavigationTransition: NSObject {
    public private(set) var animators: [NKNavigationDirection : NKAnimator] = [:]
    
    var currentAnimator: NKAnimator? = nil
    
    public subscript(direction: NKNavigationDirection) -> NKAnimator? {
        get {
        
            if let animator = self.animators[direction] {
                return animator
            }
            
            let dir1 = NKNavigationDirection(source: NKAnyViewController.self, destination: direction.destination, operation: direction.operation)
            if let animator = self.animators[dir1] {
                return animator
            }
            
            let dir2 = NKNavigationDirection(source: direction.source, destination: NKAnyViewController.self, operation: direction.operation)
            
            return self.animators[dir2]
        }
        
        set {
            self.animators[direction] = newValue
        }
    }
    
}

extension NKNavigationTransition: UINavigationControllerDelegate {
    
        public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
            
            guard let animator = self.currentAnimator else {
                return nil
            }
            
            switch animator.animationType {
            case .Both, .Interactive:
                return animator.interactive
            case .Default:
                return nil
            }
        }
    
    public func navigationController(_ animationControllerForfromtonavigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
            self.currentAnimator = self[NKNavigationDirection(source: type(of: fromVC), destination: type(of: toVC), operation: operation)]
            
            guard let animator = self.currentAnimator else {
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
    
}
