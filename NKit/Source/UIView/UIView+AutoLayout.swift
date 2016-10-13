//
//  UIView+AutoLayout.swift
//
//  Created by Nghia Nguyen on 5/26/15.
//

import UIKit

public extension UIView {
    public var nka_leading: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .leading)
    }
    
    public var nka_trailing: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .trailing)
    }
    
    public var nka_bottom: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .bottom)
    }
    
    public var nka_top: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .top)
    }
    
    public var nka_firstBaseline: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .firstBaseline)
    }
    
    public var nka_lastBaseline: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .lastBaseline)
    }
    
    public var nka_centerX: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .centerX)
    }
    
    public var nka_centerY: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .centerY)
    }
    
    public var nka_width: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .width)
    }
    
    public var nka_height: NKConstraintItem {
        return NKConstraintItem(view: self, attribute: .height)
    }
}
