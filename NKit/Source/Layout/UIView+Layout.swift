//
//  UIView+Layout.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/26/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import NTZStackView
import OAStackView
import SnapKit

public protocol NKViewIdentifier {
    var rawValue: String {get}
    var identifier: String {get}
}

public extension NKViewIdentifier {
    var identifier: String {
        return "\(String(reflecting: self.dynamicType))-\(rawValue)"
    }
}

public extension NKViewIdentifier {
    public func view<T: UIView>(fromView: UIView) -> T {
        return fromView.nk_findViewById(self)
    }
    
    public func view<T: UIView>(fromView: UIView) -> T? {
        return fromView.nk_findViewById(self)
    }
    
    public func view(fromView: UIView) -> UIView? {
        return fromView.nk_findViewById(self)
    }
    
    public func view<T: UIView>(fromViewController: UIViewController) -> T {
        return fromViewController.view.nk_findViewById(self)
    }
    
    public func view<T: UIView>(fromViewController: UIViewController) -> T? {
        return fromViewController.view.nk_findViewById(self)
    }
    
    public func view(fromViewController: UIViewController) -> UIView? {
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
    public func nk_config(config: Self -> Void) -> Self {
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
    
    public func nk_addSubview<T: UIView>(view: T, config: ((T) -> Void)? = nil) -> Self {
        self.addSubview(view)
        config?(view)
        return self
    }
    
    public func nk_addToView(view: UIView) -> Self {
        view.addSubview(self)
        return self
    }
    
    public func nk_id(id: NKViewIdentifier) -> Self {
        self.nk_id = id.identifier
        return self
    }
    
    public func nk_findViewById<T: UIView>(id: NKViewIdentifier) -> T {
        return self.nk_findViewById(id) as! T
    }
    
    public func nk_findViewById<T: UIView>(id: NKViewIdentifier) -> T? {
        return self.nk_findViewById(id) as? T
    }
    
    public func nk_findViewById(id: NKViewIdentifier) -> UIView? {
        return self._nk_findViewById(self, id: id)
    }
    
    private func _nk_findViewById(root: UIView, id: NKViewIdentifier) -> UIView? {
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
    
    public func nk_mapIds() -> Self {
        self._nk_mapIds(self)
        return self
    }
    
    private func _nk_mapIds(view: UIView) {
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
            let updateConstraints: (superView: UIView, isVertical: Bool) -> Void = { superView, isVertical in
                
                self.snp_updateConstraints { (make) in
                    if isVertical {
                        make.height.equalTo(superView).multipliedBy(newValue)
                    } else {
                        make.width.equalTo(superView).multipliedBy(newValue)
                    }
                }
            }
            
            if let superView = self.superview as? TZStackView {
                updateConstraints(superView: superView, isVertical: superView.axis == .Vertical)
            }
            
            if let superView = self.superview as? OAStackView {
                updateConstraints(superView: superView, isVertical: superView.axis == .Vertical)
            }
            
            if #available(iOS 9.0, *) {
                if let superView = self.superview as? UIStackView {
                    updateConstraints(superView: superView, isVertical: superView.axis == .Vertical)
                }
            }
        }
        
        get {
            return 0 //NPN TODO: return weight value
        }
    }
}

