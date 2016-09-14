//
//  TwoViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/12/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

class TwoViewController: UIViewController {
    
    lazy var presentationTransition: NKPresentationTransition = {
        let presentationAnimator = NKAnimator.present(duration: 1) { (context) in
            context.toView.alpha = 0
            UIView.animateWithDuration(context.duration, animations: {
                context.toView.alpha = 1
                }, completion: { (_) in
                    context.completeTransition()
            })
        }
        
        let dismissAnimator = NKAnimator.dismiss(duration: 1) { (context) in
            UIView.animateWithDuration(context.duration, animations: {
                context.fromView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.000001, 0.000001)
                }, completion: { (_) in
                    context.completeTransition()
            })
        }
        return NKPresentationTransition(presentAnimator: presentationAnimator, dismissAnimator: dismissAnimator, controller: TestController())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.greenColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.nk_setBarTintColor(UIColor.greenColor()).nk_setRightBarButton("OneViewController", selector: #selector(TwoViewController.oneView))
    }
    
    func oneView() {
        let oneViewController = OneViewController()
        
        oneViewController.transitioningDelegate = presentationTransition
        oneViewController.modalPresentationStyle = .Custom
        self.presentViewController(oneViewController, animated: true, completion: nil)
    }
}
