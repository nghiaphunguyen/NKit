//
//  UIView+Animation.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/3/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit

public enum NKAnimationType {
    case ByValue
    case ToValue
}

public extension UIView {
    //MARK: Animation
    public func nk_animateAutoLayoutWithDuration(duration: NSTimeInterval,
        completion: ((Bool) -> Void)? = nil) {
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.layoutIfNeeded()
                }, completion: completion)
            
    }
    
    public func nk_animateSpringAutoLayoutWithDuration(duration: NSTimeInterval,
        delay: NSTimeInterval = 0,
        usingSpringWithDamping damping: CGFloat = 1,
        initialSpringVelocity velocity: CGFloat = 1,
        options: UIViewAnimationOptions = .CurveEaseOut,
        completion: ((Bool) -> Void)? = nil) {
            UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: { () -> Void in
                self.layoutIfNeeded()
                }, completion: completion)
    }
    
    public func nk_animateWithKeyPath(keyPath: String,
        value: CGFloat,
        type: NKAnimationType,
        duration: Double,
        timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault),
        repeatCount: Float? = nil,
        key: String? = nil,
        completion: NKAnimationClosure? = nil) -> CAAnimation {
            let animation = CABasicAnimation(keyPath: keyPath)
            animation.duration = duration
            animation.removedOnCompletion = false
            
            let currentValue = (self.layer.presentationLayer()?.valueForKeyPath(keyPath) as? NSNumber)?.floatValue ?? 0
            animation.fromValue = currentValue
            
            switch type {
            case .ToValue:
                animation.toValue = value
            case .ByValue:
                animation.byValue = value
            }
            
            if repeatCount != nil {
                animation.repeatCount = repeatCount!
            }
            
            animation.timingFunction = timingFunction
            animation.fillMode = kCAFillModeForwards
            
            if key == nil || completion == nil {
                self.layer.addAnimation(animation, forKey: key)
            } else {
                self.layer.nk_addAnimation(animation, forKey: key!, completion: completion!)
            }
            
            return animation
    }
    
}