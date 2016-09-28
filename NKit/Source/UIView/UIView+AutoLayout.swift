//
//  UIView+AutoLayout.swift
//
//  Created by Nghia Nguyen on 5/26/15.
//

import UIKit

public extension UIView {
    public var nka_leading: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .Leading)
    }
    
    public var nka_trailing: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .Trailing)
    }
    
    public var nka_bottom: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .Bottom)
    }
    
    public var nka_top: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .Top)
    }
    
    public var nka_baseline: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .Baseline)
    }
    
    public var nka_centerX: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .CenterX)
    }
    
    public var nka_centerY: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .CenterY)
    }
    
    public var nka_width: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .Width)
    }
    
    public var nka_height: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .Height)
    }
}