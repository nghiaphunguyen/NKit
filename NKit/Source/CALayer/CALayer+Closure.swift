//
//  CALayer.swift
//
//  Created by Nghia Nguyen on 12/9/15.
//

import UIKit
import ObjectiveC

var NKAssociatedAnimationCompletionHandle: UInt8 = 0

public typealias NKAnimationClosure = (_ animation: CAAnimation, _ finished: Bool) -> Void

open class NKAnimationClosureWrapper : AnyObject {
    open var closure: NKAnimationClosure?
    open var animation: CAAnimation!
    
    init(animation: CAAnimation, closure: NKAnimationClosure?) {
        self.closure = closure
        self.animation = animation
    }
}

extension CALayer: CAAnimationDelegate {
    open var nk_completionClosure: [String: NKAnimationClosureWrapper]? {
        get {
            return objc_getAssociatedObject(self, &NKAssociatedAnimationCompletionHandle) as? [String: NKAnimationClosureWrapper]
        }
        
        set {
            objc_setAssociatedObject(self, &NKAssociatedAnimationCompletionHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    open func nk_addAnimation(animation: CAAnimation, forKey key: String, completion: @escaping NKAnimationClosure) {
        if self.nk_completionClosure == nil {
            self.nk_completionClosure = [String: NKAnimationClosureWrapper]()
        }
        
        self.nk_completionClosure![key] = NKAnimationClosureWrapper(animation: animation, closure: completion)
        
        animation.delegate = self
        
        animation.setValue(key, forKey: "animationID")
        
        self.add(animation, forKey: key)
    }
    
    open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if nk_completionClosure == nil {
            return
        }
        
        guard let keyAnim = anim.value(forKey: "animationID") as? String else {
            return
        }
        
        if let closureWrapper = self.nk_completionClosure![keyAnim] {
            closureWrapper.closure?(closureWrapper.animation, flag)
            self.nk_completionClosure![keyAnim] = nil
        }
    }
}

