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
        case BlurViewStyle(UIBlurEffect.Style)
        case DimViewColor(UIColor)
        case TapOutsideToDismiss
        case CloseButton(UIImage, CGSize)
    }
    
    private var frameOfPresentedView: ((_ presentationController: NKPresentationController) -> CGRect)?
    private lazy var closeButton: UIButton = {
       let button = UIButton()
        button.isHidden = true
        return button
    }()
    
    private var dimView: UIView = {
        let dimView = UIView()
        dimView.isHidden = true
        return dimView
    }()
    
    private var blurView: UIVisualEffectView = {
       let blurView = UIVisualEffectView()
        blurView.isHidden = true
        return blurView
    }()
    
    public convenience init(options: [Option], frameOfPresentedView frameClousure: @escaping (UIPresentationController) -> CGRect) {
        self.init(presentedViewController: UIViewController(), presenting: nil)
        
        self.frameOfPresentedView = frameClousure
        
        let dismissPresentedViewController = {
            self.presentingViewController.dismiss(animated: true, completion: nil)
        }
        
        options.forEach {
            switch $0 {
            case .BlurViewStyle(let style):
                self.blurView.effect = UIBlurEffect(style: style)
                self.blurView.isHidden = false
            case .DimViewColor(let color):
                self.dimView.backgroundColor = color
                self.dimView.isHidden = false
            case .TapOutsideToDismiss:
                self.blurView.rx_tap().bindNext({_ in dismissPresentedViewController()}).addDisposableTo(self.nk_disposeBag)
                self.dimView.rx_tap().bindNext({_ in dismissPresentedViewController()}).addDisposableTo(self.nk_disposeBag)
            case .CloseButton(let image, let size):
                self.closeButton.setImage(image, for: .normal)
                self.closeButton.isHidden = false
                self.closeButton.rx.tap.bindNext({_ in dismissPresentedViewController()}).addDisposableTo(self.nk_disposeBag)
                
                self.closeButton.snp.updateConstraints({ (make) in
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
        
        self.dimView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.blurView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.closeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Layout.ButtonTopMargin)
            make.leading.equalToSuperview().offset(Layout.ButtonLeadingMargin)
        }
        
        super.presentationTransitionWillBegin()
        
        guard self.blurView.isHidden == false
            || self.closeButton.isHidden == false
            || self.dimView.isHidden == false else {
                return
        }
        
        guard  let coordinator = self.presentedViewController.transitionCoordinator else {
            return
        }
                
        self.blurView.alpha = 0
        self.closeButton.alpha = 0
        self.dimView.alpha = 0
        coordinator.animate(alongsideTransition: { (context) in
            self.blurView.alpha = 1
            self.closeButton.alpha = 1
            self.dimView.alpha = 1
            }, completion: nil)
    }
    
    public override func dismissalTransitionWillBegin() {
        guard self.blurView.isHidden == false
            || self.closeButton.isHidden == false
            || self.dimView.isHidden == false else {
                return
        }
        
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            return
        }
        
        coordinator.animate(alongsideTransition: { (context) in
            self.blurView.alpha = 0
            self.closeButton.alpha = 0
            self.dimView.alpha = 0
            }, completion: nil)
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        if let closure = self.frameOfPresentedView {
            return closure(self)
        }
        
        return self.containerView?.bounds ?? CGRect.zero
    }
}
