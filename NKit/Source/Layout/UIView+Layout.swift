//
//  UIView+Layout.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/26/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import SnapKit

public protocol NKViewIdentifier {
    var rawValue: String {get}
    var identifier: String {get}
}

public extension NKViewIdentifier {
    var identifier: String {
        return "\(String(reflecting: type(of: self)))-\(rawValue)"
    }
}

public extension NKViewIdentifier {
    public func view<T: UIView>(_ fromView: UIView) -> T {
        return fromView.nk_findViewById(self)
    }
    
    public func view<T: UIView>(_ fromView: UIView) -> T? {
        return fromView.nk_findViewById(self)
    }
    
    public func view(_ fromView: UIView) -> UIView? {
        return fromView.nk_findViewById(self)
    }
    
    public func view<T: UIView>(_ fromViewController: UIViewController) -> T {
        return fromViewController.view.nk_findViewById(self)
    }
    
    public func view<T: UIView>(_ fromViewController: UIViewController) -> T? {
        return fromViewController.view.nk_findViewById(self)
    }
    
    public func view(_ fromViewController: UIViewController) -> UIView? {
        return fromViewController.view.nk_findViewById(self)
    }
}

public extension NKViewIdentifier {
    
}

extension String: NKViewIdentifier {
    public var rawValue: String {return self}
}

public protocol NKViewProtocol {}

public extension NKViewProtocol where Self: UIView {
    @discardableResult public func nk_config(_ config: (Self) -> Void) -> Self {
        config(self)
        return self
    }
}

extension UIView: NKViewProtocol {}

private var NKAssociatedKeyId: UInt8 = 100
private var NKAssociatedKeySubviews: UInt8 = 101

public extension UIView {
    
    public var nk_subviews: [String : UIView] {
        get {
            guard let subviews = (objc_getAssociatedObject(self, &NKAssociatedKeySubviews) as? [String: UIView]) else {
                let result = [String: UIView]()
                self.nk_subviews = result
                return result
            }
            
            return subviews
        }
        
        set {
            objc_setAssociatedObject(self, &NKAssociatedKeySubviews, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //NPN TODO: Some views is still be stored instead id is invalid
    public var nk_id: String? {
        get {
            return objc_getAssociatedObject(self, &NKAssociatedKeyId) as? String
        }
        
        set {
            objc_setAssociatedObject(self, &NKAssociatedKeyId, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult public func nk_addSubview<T: UIView>(_ view: T, config: ((T) -> Void)? = nil) -> Self {
        self.addSubview(view)
        config?(view)
        return self
    }
    
    @discardableResult public func nk_addToView(_ view: UIView) -> Self {
        view.addSubview(self)
        return self
    }
    
    public func nk_id(_ id: NKViewIdentifier) -> Self {
        self.nk_id = id.identifier
        return self
    }
    
    public func nk_findViewById<T: UIView>(_ id: NKViewIdentifier) -> T {
        return self.nk_findViewById(id) as! T
    }
    
    public func nk_findViewById<T: UIView>(_ id: NKViewIdentifier) -> T? {
        return self.nk_findViewById(id) as? T
    }
    
    public func nk_findViewById(_ id: NKViewIdentifier) -> UIView? {
        return self._nk_findViewById(self, id: id)
    }
    
    private func _nk_findViewById(_ root: UIView, id: NKViewIdentifier) -> UIView? {
        if let view = self.nk_subviews[id.identifier] {
            return view
        }
        
        for view in self.subviews {
            guard let viewId = view.nk_id else { continue }
            
            root.nk_subviews[viewId] = view
            
            if viewId == id.identifier {
                return view
            }
        }
        
        for view in self.subviews {
            if let v = view._nk_findViewById(root, id: id) {
                return v
            }
        }
        
        return nil
    }
    
    @discardableResult public func nk_mapIds() -> Self {
        self._nk_mapIds(self)
        return self
    }
    
    
    public func nk_keepSize(num: Float = 1, axis: UILayoutConstraintAxis = .horizontal) -> Self {
        let huggingPriority: Float = 250 + num * 10
        self.setContentHuggingPriority(huggingPriority, for: axis)
        
        let resistancePriority: Float = 750 + num * 10
        self.setContentCompressionResistancePriority(resistancePriority, for: axis)
        return self
        
    }
    
    private func _nk_mapIds(_ view: UIView) {
        if let id = self.nk_id {
            view.nk_subviews[id] = self
        }
        
        for v in self.subviews {
            v._nk_mapIds(view)
        }
    }
}

public extension UIView {
    public var nka_weight: CGFloat {
        set {
            let updateConstraints: (_ superView: UIView, _ isVertical: Bool) -> Void = { superView, isVertical in
                
                self.snp.updateConstraints { (make) in
                    if isVertical {
                        make.height.equalTo(superView).multipliedBy(newValue)
                    } else {
                        make.width.equalTo(superView).multipliedBy(newValue)
                    }
                }
            }
            
            if let superView = self.superview as? UIStackView {
                updateConstraints(superView, superView.axis == .vertical)
            }
            
            if let superView = self.superview as? UIStackView {
                updateConstraints(superView, superView.axis == .vertical)
            }
            
            if #available(iOS 9.0, *) {
                if let superView = self.superview as? UIStackView {
                    updateConstraints(superView, superView.axis == .vertical)
                }
            }
        }
        
        get {
            return 0 //NPN TODO: return weight value
        }
    }
}

public struct NKViewConfiguration<T> {
    let view: T
    let config: (T) -> Void
}

precedencegroup NKOperator160 {
    higherThan: NKOperator150
}
precedencegroup NKOperator151 {
    higherThan: NKOperator150
    associativity: left
}

precedencegroup NKOperator150 {
    higherThan: NKOperator140
}

precedencegroup NKOperator140 {
    associativity: left
}

precedencegroup NKOperator130 {}

infix operator ~ : NKOperator160
public func ~ <T: UIView>(left: T, right: NKViewIdentifier) -> T {
    return left.nk_id(right)
}

infix operator >>> : NKOperator150
public func >>> <T: UIView>(left: T, right: @escaping (T) -> Void) -> NKViewConfiguration<T> {
    return NKViewConfiguration(view: left, config: right)
}

infix operator <> : NKOperator151
public func <> <T: UIView>(left: T, right: (T) -> Void) -> T {
    right(left)
    
    return left
}

infix operator <<< : NKOperator140
public func <<< <T: UIView, U: UIView>(left: T, right: U) -> T {
    return left.nk_addSubview(right)
}

public func <<< <T: UIStackView, U: UIView>(left: T, right: U) -> T {
    return left.nk_addArrangedSubview(right)
}

public func <<< <T: UIView, U: UIView>(left: T, right: NKViewConfiguration<U>) -> T {
    return left.nk_addSubview(right.view, config: right.config)
}

public func <<< <T: UIStackView
    , U: UIView>(left: T, right: NKViewConfiguration<U>) -> T {
    return left.nk_addArrangedSubview(right.view, config: right.config)
}

public var MAP = NKLayoutMapping.Ids
public enum NKLayoutMapping {
    case Ids
}

infix operator <-> : NKOperator130
public func <-> <T: UIView>(left: T, right: NKLayoutMapping) -> T {
    return left.nk_mapIds()
}
