//
//  TestTransitionViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/22/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit


extension NKPresentationTransition {
    static var popupTransition: NKPresentationTransition {
        return NKPresentationTransition(presentAnimator: NKAnimator.present(duration: 3, animations: { content in
            
            content.toView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                content.toView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }, completion: {
                content.completeTransition(didComplete: $0)
            })
            
        }), dismissAnimator: nil, controller: NKPresentationController(options: [.DimViewColor(UIColor.black.withAlphaComponent(0.5)), .TapOutsideToDismiss], sizeOfPresentedView: CGSize(width: 120, height: 120)))
    }
}

class TestTransitionViewController: UIViewController {
    let transition = NKPresentationTransition.popupTransition
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.blue
        self.view.nk_addSubview(UIButton()) {
            $0.setTitle("tapMe", for: .normal)
            $0.snp.makeConstraints({ (make) in
                make.center.equalToSuperview()
            })
            $0.rx.tap.bindNext { [unowned self] in
                let viewController = AlertViewController()
                viewController.transitioningDelegate = self.transition
                viewController.modalPresentationStyle = .custom
                self.present(viewController, animated: true, completion: nil)
            }.addDisposableTo(self.nk_disposeBag)
        }
    }
}

extension TestTransitionViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transition.presentAnimator
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self.transition.controller
    }
}

class AlertViewController: UIViewController {
    override func loadView() {
        super.loadView()
        
        print("transition delegate = \(self.transitioningDelegate)")
        self.view.backgroundColor = UIColor.red
    }
}
