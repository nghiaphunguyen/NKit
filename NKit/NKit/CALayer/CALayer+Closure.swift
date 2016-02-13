//
//  CALayer.swift
//
//  Created by Nghia Nguyen on 12/9/15.
//

import UIKit

import ObjectiveC

var NKAssociatedAnimationCompletionHandle: UInt8 = 0

public typealias NKAnimationClosure = (animation: CAAnimation, finished: Bool) -> Void

public class NKAnimationClosureWrapper : AnyObject {
    public var closure: NKAnimationClosure?
    public var animation: CAAnimation!
    
    init(animation: CAAnimation, closure: NKAnimationClosure?) {
        self.closure = closure
        self.animation = animation
    }
}

public extension CALayer {
    public var nk_completionClosure: [String: NKAnimationClosureWrapper]? {
        get {
            return objc_getAssociatedObject(self, &NKAssociatedAnimationCompletionHandle) as? [String: NKAnimationClosureWrapper]
        }
        
        set {
            objc_setAssociatedObject(self, &NKAssociatedAnimationCompletionHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public func nk_addAnimation(animation: CAAnimation, forKey key: String, completion: NKAnimationClosure) {
        if self.nk_completionClosure == nil {
            self.nk_completionClosure = [String: NKAnimationClosureWrapper]()
        }
        
        self.nk_completionClosure![key] = NKAnimationClosureWrapper(animation: animation, closure: completion)
        
        animation.delegate = self
        
        animation.setValue(key, forKey: "animationID")
        
        self.addAnimation(animation, forKey: key)
    }
    
    public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if nk_completionClosure == nil {
            return
        }
        
        guard let keyAnim = anim.valueForKey("animationID") as? String else {
            return
        }
        
        if let closureWrapper = self.nk_completionClosure![keyAnim] {
            closureWrapper.closure?(animation: closureWrapper.animation, finished: flag)
            self.nk_completionClosure![keyAnim] = nil
        }
    }
}

