//
//  NKPopupView.swift
//
//  Created by Nghia Nguyen on 3/13/16.
//

import UIKit

public class NKPopupView<T: UIView>: NKContainerView<T>, UIGestureRecognizerDelegate {
    
    public var tapOutsideWillDismiss = true
    public var animationShow: ((completion: () -> Void) -> Void)?
    public var animationDismiss: ((completion: () -> Void) -> Void)?
    
    public init(frame: CGRect = CGRectMake(0, 0, NKScreenSize.Current.width, NKScreenSize.Current.height),
        backgroundColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.5),
        contentView: T? = nil) {
            super.init(frame: frame)
            
            self.contentView = contentView
            self.backgroundColor = backgroundColor
            
            let tapGesture = UITapGestureRecognizer()
            tapGesture.delegate = self
            self.addGestureRecognizer(tapGesture)
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if let contentView = self.contentView where touch.view?.isDescendantOfView(contentView) == true {
            return false
        }
        
        if self.tapOutsideWillDismiss {
            self.dismiss()
        }
        
        return true
    }
    
    public func show(inView view: UIView, completion: (() -> Void)? = nil) {
        view.addSubview(self)
        self.contentView?.hidden = false
        self.contentView?.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0)
        
        if let animationShow = self.animationShow {
            animationShow(completion: { () -> Void in
                completion?()
            })
            
            return
        }
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.contentView?.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
            }, completion: { (result) in
                completion?()
        })
    }
    
    public func dismiss(completion: (() -> Void)? = nil) {
        
        let finish = {
            self.contentView?.hidden = true
            self.removeFromSuperview()
            completion?()
        }
        
        if let animationDismiss = self.animationDismiss {
            animationDismiss(completion: { () -> Void in
                finish()
            })
            
            return
        }
        
        // animation show
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.contentView?.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.000001, 0.000001)
            }, completion: { (result) in
                finish()
        })
    }
}