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

class OneViewController: UIViewController {
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Push", forState: .Normal)
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Dismiss", forState: .Normal)
        return button
    }()
    
    lazy var pushAnimator = NKAnimator(duration: 0.5, transitionType: .Push, animationType: .Both , animations: { (animator) in
        animator.toView.alpha = 0
        
        UIView.animateWithDuration(animator.duration, animations: {
            animator.toView.alpha = 1
            }, completion: { (_) in
                animator.completeTransition()
        })
    })
    
    lazy var dismissAnimator = NKAnimator(duration: 0.5, transitionType: .Pop, animationType: .Default, animations: { (animator) in
        UIView.animateWithDuration(animator.duration, animations: {
            animator.fromView.alpha = 0
            }, completion: { (_) in
                animator.completeTransition()
        })
    })
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        
//        modalPresentationStyle = UIModalPresentationStyle.Custom
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.button)
        self.button.snp_makeConstraints { (make) in
            make.center.equalTo(0)
        }
        
        self.view.addSubview(self.dismissButton)
        self.dismissButton.snp_makeConstraints { (make) in
            make.top.equalTo(0).offset(100)
            make.centerX.equalTo(0)
        }
        
        self.button.rx_tap.bindNext { 
            self.navigationController?.pushViewController(TestKeyboardAutoScrollingViewController(), animated: true)
        }.addDisposableTo(self.nk_disposeBag)
        
        self.dismissButton.rx_tap.bindNext { 
            self.dismissViewControllerAnimated(true, completion: nil)
        }.addDisposableTo(self.nk_disposeBag)
        
        self.view.backgroundColor = UIColor.blueColor()
        
        self.view.rx_pan().bindNext { (gesture) in
            let location = gesture.locationInView(self.view?.window)
            
            if gesture.state == .Began {
                self.startX = location.x
                self.pushAnimator.startInteractiveTransition()
                self.navigationController?.pushViewController(TestKeyboardAutoScrollingViewController(), animated: true)
            }
            
            if gesture.state == .Changed {
                var d = (location.x - self.startX)
                d = max(0, min(1, d / 100))
                print("update interactiveAnimate=\(d)")
                self.pushAnimator.updateInteractiveTransition(d)
            }
            
            if gesture.state == .Cancelled {
                self.pushAnimator.cancelInteractiveTransition()
            }
            
            if gesture.state == .Ended {
                var d = (location.x - self.startX)
                d = max(0, min(1, d / 100))
                let velocity = gesture.velocityInView(self.view.window).x
                print("update interactiveAnimate=\(d) velocity=\(velocity)")
                if d > 0.7 || velocity  > 300 {
                    self.pushAnimator.finishInteractiveTransition()
                } else {
                    self.pushAnimator.cancelInteractiveTransition()
                }
            }
        }.addDisposableTo(self.nk_disposeBag)
        
    }
    
    
    var startX: CGFloat = -1
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.nk_transition[NKAnyViewController.self >> TestKeyboardAutoScrollingViewController.self] = self.pushAnimator
        
        self.navigationController?.nk_transition[self << NKAnyViewController.self] = self.dismissAnimator

        
        self.navigationController?.nk_transition[self >> TwoViewController.self] = self.pushAnimator.clone()
        
        self.navigationController?.delegate = self.navigationController?.nk_transition
        self.nk_setBarTintColor(UIColor.whiteColor()).nk_setRightBarButton("TwoViewController", selector: #selector(OneViewController.moveToTwoViewController))
    }
    
    func moveToTwoViewController() {
        self.navigationController?.pushViewController(TwoViewController(), animated: true)
    }
    
}

class TestController: UIPresentationController {
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return self.containerView?.bounds.insetBy(dx: 100, dy: 100) ?? CGRect.zero
    }
}