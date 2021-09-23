//
//  NKPopupView.swift
//
//  Created by Nghia Nguyen on 3/13/16.
//

import UIKit

public typealias NKVoidClosure = () -> Void

open class NKPopupView<T: UIView>: NKContainerView<T>, UIGestureRecognizerDelegate {
    
    open var tapOutsideWillDismiss = true
    
    public init(frame: CGRect = CGRect(x: 0, y: 0, width: NKScreenSize.Current.width, height: NKScreenSize.Current.height),
        backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.5),
        contentView: T? = nil) {
            super.init(frame: frame)
            
        self.contentView = contentView
        self.backgroundColor = backgroundColor
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let contentView = self.contentView , touch.view?.isDescendant(of: contentView) == true {
            return false
        }
        
        if self.tapOutsideWillDismiss {
            self.dismiss()
        }
        
        return true
    }
    
    open func show(inView view: UIView, completion: (() -> Void)? = nil) {
        view.addSubview(self)
        self.contentView?.isHidden = false
        self.contentView?.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
//        
//        if let animationShow = self.animationShow {
//            animationShow({ () -> Void in
//                completion?()
//            })
//            
//            return
//        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            self.contentView?.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            }, completion: { (result) in
                completion?()
        })
    }
    
    open func dismiss(completion: (() -> Void)? = nil) {
        
        let finish = {
            self.contentView?.isHidden = true
            self.removeFromSuperview()
            completion?()
        }
        
//        if let animationDismiss = self.animationDismiss {
//            animationDismiss({ () -> Void in
//                finish()
//            })
//            
//            return
//        }
        
        // animation show
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            
            self.contentView?.transform = CGAffineTransform.identity.scaledBy(x: 0.000001, y: 0.000001)
            }, completion: { (result) in
                
                finish()
        })
    }
}
