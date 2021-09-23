//
//  UINavigationController+Animation.swift
//
//  Created by Nghia Nguyen on 12/7/15.
//

import UIKit

public extension UINavigationController {
    public func nk_animationPushToViewController(_ viewController: UIViewController,
        duration: TimeInterval = 0.3,
                                                 type: CATransitionType = CATransitionType.moveIn,
                                                 subType: CATransitionSubtype = CATransitionSubtype.fromBottom,
                                                 timingFunc: CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)) {
            let animation = CATransition()
            animation.duration = duration
            animation.type = type
            animation.subtype = subType
            animation.timingFunction = timingFunc
            self.pushViewController(viewController, animated: false)
            self.view.layer.add(animation, forKey: nil)
    }
    
    public func nk_animationPop(duration: TimeInterval = 0.3,
        type: CATransitionType = CATransitionType.moveIn,
        subType: CATransitionSubtype = CATransitionSubtype.fromBottom,
                                timingFunc: CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)) {
            let animation = CATransition()
            animation.duration = duration
            animation.type = type
            animation.subtype = subType
            animation.timingFunction = timingFunc
            self.view.layer.add(animation, forKey: nil)
            self.popViewController(animated: false)
    }
    
    public func nk_animateToViewController(_ viewController: UIViewController) {
        nk_animationPushToViewController(viewController, duration: 0.3, type: CATransitionType.moveIn, subType: CATransitionSubtype.fromRight)
    }
    
    public func nk_animatePushFromBottomToViewController(_ viewController: UIViewController) {
        self.nk_animationPushToViewController(viewController, duration: 0.3, type: CATransitionType.moveIn, subType: CATransitionSubtype.fromTop)
    }
    
    public func nk_animatePopByFading() {
        self.nk_animationPop(duration: 0.5, type: CATransitionType.fade, subType: CATransitionSubtype.fromRight)
    }
    
    public func nk_animatePopFromTop() {
        self.nk_animationPop(duration: 0.3, type: CATransitionType.reveal, subType: CATransitionSubtype.fromBottom)
    }
    
    public func nk_animatePopFromLeft() {
        self.nk_animationPop(duration: 0.3, type: CATransitionType.moveIn, subType: CATransitionSubtype.fromLeft)
    }
    
    public func nk_animatePopFromTopToViewController(_ viewController: UIViewController) {
        let indexOfSaveVC: Int = self.viewControllers.index(of: viewController) ?? 0
        var indexToPopNoAnimation: Int = self.viewControllers.count - 1
        while indexToPopNoAnimation > indexOfSaveVC + 1 {
            self.popViewController(animated: false)
            indexToPopNoAnimation -= 1
        }
        
        self.nk_animationPop(duration: 0.3, type: CATransitionType.reveal, subType: CATransitionSubtype.fromBottom)
    }
    
    public func nk_animationPopToViewControllerClass(_ viewControllerClass: AnyClass) -> Bool {
        if let viewController = self.nk_viewControllerOfClass(viewControllerClass) {
            self.nk_animatePopFromTopToViewController(viewController)
            return true
        }
        
        return false
    }
    
    public func nk_viewControllerOfClass(_ viewControllerClass: AnyClass) -> UIViewController? {
        for vc: UIViewController in self.viewControllers {
            if vc.isKind(of: viewControllerClass) {
                return vc
            }
        }
        return nil
    }
}
