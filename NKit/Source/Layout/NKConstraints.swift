//
//  NKConstraints.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/28/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public struct NKConstraintItem {
    let view: UIView
    let attribute: NSLayoutAttribute
    
    public func constraintWithRelativeItem(right: NKConstraintRelativeItem, relation: NSLayoutRelation) -> NSLayoutConstraint {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        right.item?.view.translatesAutoresizingMaskIntoConstraints = false
        
        let attribute = right.item?.attribute ?? self.attribute
        
        return NSLayoutConstraint(item: self.view, attribute: self.attribute, relatedBy: relation, toItem: right.item?.view, attribute: attribute, multiplier: right.multiple, constant: right.constant)
    }
}

public struct NKConstraintRelativeItem {
    let item: NKConstraintItem?
    let multiple: CGFloat
    let constant: CGFloat
    let priority: UInt
    
    public init(item: NKConstraintItem? = nil, multiple: CGFloat = 1, constant: CGFloat = 0, priority: UInt = 1000) {
        self.item = item
        self.multiple = multiple
        self.constant = constant
        self.priority = priority
    }
}

public func +(left: NKConstraintItem, right: CGFloat) -> NKConstraintRelativeItem {
    return NKConstraintRelativeItem(item: left, constant: right)
}

public func -(left: NKConstraintItem, right: CGFloat) -> NKConstraintRelativeItem {
    return left + (-right)
}

public func *(left: NKConstraintItem, right: CGFloat) -> NKConstraintRelativeItem {
    return NKConstraintRelativeItem(item: left, multiple: right, constant: 0)
}

public func /(left: NKConstraintItem, right: CGFloat) -> NKConstraintRelativeItem {
    return left * (1 / right)
}

public func +(left: NKConstraintRelativeItem, right: CGFloat) -> NKConstraintRelativeItem {
    return NKConstraintRelativeItem(item: left.item, multiple: left.multiple, constant: right + left.constant)
}

public func -(left: NKConstraintRelativeItem, right: CGFloat) -> NKConstraintRelativeItem {
    return left + (-right)
}

public func *(left: NKConstraintRelativeItem, right: CGFloat) -> NKConstraintRelativeItem {
    return NKConstraintRelativeItem(item: left.item, multiple: right * left.multiple, constant: left.constant)
}

public func /(left: NKConstraintRelativeItem, right: CGFloat) -> NKConstraintRelativeItem {
    return left * (1 / right)
}

public func ~(left: NKConstraintRelativeItem, right: UInt) -> NKConstraintRelativeItem {
    return NKConstraintRelativeItem(item: left.item, multiple: left.multiple, constant: left.constant, priority: right)
}

public func ~(left: CGFloat, right: UInt) -> NKConstraintRelativeItem {
    return NKConstraintRelativeItem(item: nil, constant: left, priority: right)
}

public func ==(left: NKConstraintItem, right: NKConstraintItem) -> NSLayoutConstraint {
    let relativeItem = NKConstraintRelativeItem(item: right)
    
    let result = left.constraintWithRelativeItem(right: relativeItem, relation: .equal)
    result.isActive = true
    return result
}

public func >=(left: NKConstraintItem, right: NKConstraintItem) -> NSLayoutConstraint {
    let relativeItem = NKConstraintRelativeItem(item: right)
    let result = left.constraintWithRelativeItem(right: relativeItem, relation: .greaterThanOrEqual)
    result.isActive = true
    return result
}

public func <=(left: NKConstraintItem, right: NKConstraintItem) -> NSLayoutConstraint {
    let relativeItem = NKConstraintRelativeItem(item: right)
    
    let result = left.constraintWithRelativeItem(right: relativeItem, relation: .lessThanOrEqual)
    result.isActive = true
    return result
}

public func ==(left: NKConstraintItem, right: NKConstraintRelativeItem) -> NSLayoutConstraint {
    let result = left.constraintWithRelativeItem(right: right, relation: .equal)
    result.isActive = true
    return result
}

public func >=(left: NKConstraintItem, right: NKConstraintRelativeItem) -> NSLayoutConstraint {
    let result = left.constraintWithRelativeItem(right: right, relation: .greaterThanOrEqual)
    result.isActive = true
    return result
}

public func <=(left: NKConstraintItem, right: NKConstraintRelativeItem) -> NSLayoutConstraint {
    let result = left.constraintWithRelativeItem(right: right, relation: .lessThanOrEqual)
    result.isActive = true
    return result
}

public func ==(left: NKConstraintItem, right: CGFloat) -> NSLayoutConstraint {
    
    let relativeItem = NKConstraintRelativeItem(constant: right)
    
    let result = left.constraintWithRelativeItem(right: relativeItem, relation: .equal)
    result.isActive = true
    return result
}

public func >=(left: NKConstraintItem, right: CGFloat) -> NSLayoutConstraint {
    let relativeItem = NKConstraintRelativeItem(constant: right)
    
    let result = left.constraintWithRelativeItem(right: relativeItem, relation: .greaterThanOrEqual)
    result.isActive = true
    return result
}

public func <=(left: NKConstraintItem, right: CGFloat) -> NSLayoutConstraint {
    let relativeItem = NKConstraintRelativeItem(constant: right)
    
    let result = left.constraintWithRelativeItem(right: relativeItem, relation: .lessThanOrEqual)
    result.isActive = true
    return result
}
