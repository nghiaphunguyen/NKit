//
//  NKTextFieldAutoMove.swift
//
//  Created by Nghia Nguyen on 3/13/16.
//

import UIKit

var NKTextFieldEdgeInsetToken: UInt8 = 0

public class NKEdgeInsetWrapper: AnyObject {
    var edgeInset: UIEdgeInsets?
    
    init(edgeInset: UIEdgeInsets?) {
        self.edgeInset = edgeInset
    }
}

public class NKTextField: UITextField {
    
    var edgeInsetWrapper: NKEdgeInsetWrapper? {
        get {
            return objc_getAssociatedObject(self, &NKTextFieldEdgeInsetToken) as? NKEdgeInsetWrapper
        }
        
        set {
            objc_setAssociatedObject(self, &NKTextFieldEdgeInsetToken, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
}