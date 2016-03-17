//
//  NKTextFieldAutoMove.swift
//
//  Created by Nghia Nguyen on 3/13/16.
//

import UIKit

var NKTextFieldEdgeInsetToken: UInt8 = 0

class NKEdgeInsetWrapper: AnyObject {
    var edgeInset: UIEdgeInsets?
    
    init(edgeInset: UIEdgeInsets?) {
        self.edgeInset = edgeInset
    }
}

public class NKTextField: UITextField {
    
    struct Constants {
        static let KeyboardHeight: CGFloat = 256
    }
    
    private var edgeInsetWrapper: NKEdgeInsetWrapper? {
        get {
            return objc_getAssociatedObject(self, &NKTextFieldEdgeInsetToken) as? NKEdgeInsetWrapper
        }
        
        set {
            objc_setAssociatedObject(self, &NKTextFieldEdgeInsetToken, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    //MARK: Public porperties
    public var scrollView: UIScrollView? {
        
        didSet {
            if scrollView != nil {
                self.addTarget(self, action: "edittingDidBegin", forControlEvents: UIControlEvents.EditingDidBegin)
                self.addTarget(self, action: "edittingDidEnd", forControlEvents: UIControlEvents.EditingDidEnd)
            }
        }
    }
    
    public var edgeInset: UIEdgeInsets {
        get {
            return self.edgeInsetWrapper?.edgeInset ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        set {
            if self.edgeInsetWrapper == nil {
                self.edgeInsetWrapper = NKEdgeInsetWrapper(edgeInset: newValue)
            } else {
                self.edgeInsetWrapper?.edgeInset = newValue
            }
        }
    }
    
    public override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.origin.x + edgeInset.left,
            bounds.origin.y + edgeInset.top,
            bounds.size.width - edgeInset.left - edgeInset.right,
            bounds.size.height - edgeInset.top - edgeInset.bottom)
    }
    
    public override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.origin.x + edgeInset.left,
            bounds.origin.y + edgeInset.top,
            bounds.size.width - edgeInset.left - edgeInset.right,
            bounds.size.height - edgeInset.top - edgeInset.bottom)
    }
    
    //MARK: Events
    func edittingDidBegin() {
        let point = self.superview?.convertPoint(CGPointMake(self.nk_x, self.nk_y), toView: nil) ?? CGPoint.zero
        let bottomYTextField = point.y + self.nk_height
        let keyboardYOffset = NKScreenSize.Current.height - Constants.KeyboardHeight //NPN: Refactor it
        
        self.scrollView?.contentSize = CGSizeMake(self.scrollView?.contentSize.width ?? 0, self.scrollView?.contentSize.height ?? 0 + Constants.KeyboardHeight)
        if bottomYTextField > keyboardYOffset {
            let yOffset = (bottomYTextField - keyboardYOffset + 10)
            self.scrollView?.setContentOffset(CGPointMake(0, yOffset), animated: true)
        }
    }
    
    func edittingDidEnd() {
        self.scrollView?.contentSize = CGSizeMake(self.scrollView?.contentSize.width ?? 0, self.scrollView?.contentSize.height ?? 0 - Constants.KeyboardHeight)
        self.scrollView?.setContentOffset(CGPointMake(0, 0), animated: true)
    }
}