//
//  UIViewController+Loading.swift
//
//  Created by Nghia Nguyen on 12/7/15.
//

import UIKit

import ObjectiveC

var NKAssociatedLoadingViewHandle: UInt8 = 0

public extension UIViewController{
    
    private var nk_loadingView: UIView? {
        get {
            return objc_getAssociatedObject(self, &NKAssociatedLoadingViewHandle) as? UIView
        }
        
        set {
            objc_setAssociatedObject(self, &NKAssociatedLoadingViewHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func nk_showLoadingViewWithMessage(message: String,
        font: UIFont = UIFont.systemFont(ofSize: 14),
        textColor: UIColor = UIColor.white,
        backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3),
        loadingImage: UIImage? = nil) {
            
            if self.nk_loadingView?.superview != nil {
                return
            }
            
            if self.nk_loadingView == nil {
                self.nk_loadingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.nk_width, height: self.view.nk_height))
            } else {
                for view in self.nk_loadingView!.subviews {
                    view.removeFromSuperview()
                }
            }
            
            if self.nk_loadingView?.superview == nil {
                self.view.addSubview(self.nk_loadingView!)
            }
            
            self.nk_loadingView?.backgroundColor = backgroundColor
            
            let label = UILabel(text: message, color: textColor, isSizeToFit: true, alignment: .center)
            
            let loadingImageView = UIImageView(image: loadingImage)
            
            self.nk_loadingView?.addSubview(label)
            self.nk_loadingView?.addSubview(loadingImageView)
            
            
            loadingImageView.nk_width = loadingImageView.nk_imageWidth
            loadingImageView.nk_height = loadingImageView.nk_imageHeight
            loadingImageView.nk_centerHorizontalParent().nk_alignBottomView(label, offset: -15)
            
            loadingImageView.nk_animateWithKeyPath(keyPath: "transform.rotation.z",
                value: CGFloat(M_PI * 2),
                type: NKAnimationType.ByValue,
                duration: 1,
                timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
                repeatCount: HUGE)
    }
    
    public func nk_hideLoadingView() {
        self.nk_loadingView?.removeFromSuperview()
    }
}
