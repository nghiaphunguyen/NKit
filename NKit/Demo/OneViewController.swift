//
//  OneViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/11/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxGesture

class OneViewController: UIViewController {
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Push", forState: .Normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.button)
        self.button.snp_makeConstraints { (make) in
            make.center.equalTo(0)
        }
        
        self.button.rx_tap.bindNext { 
            self.navigationController?.pushViewController(TestKeyboardAutoScrollingViewController(), animated: true)
        }.addDisposableTo(self.nk_disposeBag)
        
        self.view.backgroundColor = UIColor.blueColor()
        
        self.view.rx_pan().bindNext { (gesture) in
            let location = gesture.locationInView(self.view?.window)
            
            if gesture.state == .Began {
                self.startX = location.x
                self.nk_navigationAnimator.pushInteractiveAnimator = UIPercentDrivenInteractiveTransition()
                self.navigationController?.pushViewController(TestKeyboardAutoScrollingViewController(), animated: true)
            }
            
            if gesture.state == .Changed {
                var d = (location.x - self.startX)
                d = max(0, min(1, d / 100))
                print("update interactiveAnimate=\(d)")
                self.nk_navigationAnimator.pushInteractiveAnimator?.updateInteractiveTransition(d)
            }
            
            if gesture.state == .Cancelled {
                self.nk_navigationAnimator.pushInteractiveAnimator?.cancelInteractiveTransition()
                self.nk_navigationAnimator.pushInteractiveAnimator = nil
            }
            
            if gesture.state == .Ended {
                var d = (location.x - self.startX)
                d = max(0, min(1, d / 100))
                let velocity = gesture.velocityInView(self.view.window).x
                print("update interactiveAnimate=\(d) velocity=\(velocity)")
                if d > 0.7 || velocity  > 300 {
                    self.nk_navigationAnimator.pushInteractiveAnimator?.finishInteractiveTransition()
                } else {
                    self.nk_navigationAnimator.pushInteractiveAnimator?.cancelInteractiveTransition()
                }
                
                self.nk_navigationAnimator.pushInteractiveAnimator = nil
            }
        }.addDisposableTo(self.nk_disposeBag)
        
    }
    
    
    var startX: CGFloat = -1
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.nk_navigationAnimator.pushAnimator = NKAnimator(duration: 0.5, animations: { (animator) in
            animator.toView.alpha = 0
            
            UIView.animateWithDuration(animator.duration, animations: { 
                animator.toView.alpha = 1
                }, completion: { (_) in
                    animator.completeTransition()
            })
        })
        
        self.navigationController?.delegate = self.nk_navigationAnimator
        self.nk_setBarTintColor(UIColor.whiteColor())
    }
    
    
}