//
//  NKPresentationController.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/22/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public final class NKPresentationController: UIPresentationController {
    
    private struct Layout {
        static var ButtonTopMargin: CGFloat {return 20}
        static var ButtonLeadingMargin: CGFloat {return 10}
    }
    
    public enum Option {
        case BlurViewStyle(UIBlurEffectStyle)
        case DimViewColor(UIColor)
        case TapOutsideToDismiss
        case CloseButton(UIImage, CGSize)
    }
    
    private var frameOfPresentedView: ((presentationController: NKPresentationController) -> CGRect)?
    private lazy var closeButton: UIButton = {
       let button = UIButton()
        button.hidden = true
        return button
    }()
    
    private var dimView: UIView = {
        let dimView = UIView()
        dimView.hidden = true
        return dimView
    }()
    
    private var blurView: UIVisualEffectView = {
       let blurView = UIVisualEffectView()
        blurView.hidden = true
        return blurView
    }()
    
    public convenience init(options: [Option], frameOfPresentedView frameClousure: (UIPresentationController) -> CGRect) {
        self.init(presentedViewController: UIViewController(), presentingViewController: nil)
        
        self.frameOfPresentedView = frameClousure
        
        let dismissPresentedViewController = {
            self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        options.forEach {
            switch $0 {
            case .BlurViewStyle(let style):
                self.blurView.effect = UIBlurEffect(style: style)
                self.blurView.hidden = false
            case .DimViewColor(let color):
                self.dimView.backgroundColor = color
                self.dimView.hidden = false
            case .TapOutsideToDismiss:
                self.blurView.rx_tap().bindNext({_ in dismissPresentedViewController()}).addDisposableTo(self.nk_disposeBag)
                self.dimView.rx_tap().bindNext({_ in dismissPresentedViewController()}).addDisposableTo(self.nk_disposeBag)
            case .CloseButton(let image, let size):
                self.closeButton.setImage(image, forState: .Normal)
                self.closeButton.hidden = false
                self.closeButton.rx_tap.bindNext({_ in dismissPresentedViewController()}).addDisposableTo(self.nk_disposeBag)
                
                self.closeButton.snp_updateConstraints(closure: { (make) in
                    make.size.equalTo(size)
                })
            }
        }
    }
    
    public convenience init(options: [Option], sizeOfPresentedView size: CGSize) {
        self.init(options: options, frameOfPresentedView: { presentationController in
            return presentationController.containerView?.nk_frameAtCenterWithSize(size) ?? CGRect.zero
        })
    }
    
    public override func presentationTransitionWillBegin() {
        self.containerView?.addSubview(self.dimView)
        self.containerView?.addSubview(self.blurView)
        self.containerView?.addSubview(self.closeButton)
        
        self.dimView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        self.blurView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        self.closeButton.snp_makeConstraints { (make) in
            make.top.equalTo(0).offset(Layout.ButtonTopMargin)
            make.leading.equalTo(0).offset(Layout.ButtonLeadingMargin)
        }
        
        super.presentationTransitionWillBegin()
        
        guard self.blurView.hidden == false
            || self.closeButton.hidden == false
            || self.dimView.hidden == false else {
                return
        }
        
        guard  let coordinator = self.presentedViewController.transitionCoordinator() else {
            return
        }
                
        self.blurView.alpha = 0
        self.closeButton.alpha = 0
        self.dimView.alpha = 0
        coordinator.animateAlongsideTransition({ (context) in
            self.blurView.alpha = 1
            self.closeButton.alpha = 1
            self.dimView.alpha = 1
            }, completion: nil)
    }
    
    public override func dismissalTransitionWillBegin() {
        guard self.blurView.hidden == false
            || self.closeButton.hidden == false
            || self.dimView.hidden == false else {
                return
        }
        
        guard let coordinator = self.presentedViewController.transitionCoordinator() else {
            return
        }
        
        coordinator.animateAlongsideTransition({ (context) in
            self.blurView.alpha = 0
            self.closeButton.alpha = 0
            self.dimView.alpha = 0
            }, completion: nil)
    }
    
    public override func frameOfPresentedViewInContainerView() -> CGRect {
        if let closure = self.frameOfPresentedView {
            return closure(presentationController: self)
        }
        
        return self.containerView?.bounds ?? CGRect.zero
    }
}
