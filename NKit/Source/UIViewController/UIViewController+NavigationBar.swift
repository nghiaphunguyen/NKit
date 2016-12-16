//
//  UIView+NavigationBar.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 11/22/15.
//  Copyright © 2015 MisfitUILib. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    public static var kMFLNavigationBarFontSize: CGFloat {
        get {
            return 14
        }
    }
    
    public var nk_navigationBarHeight: CGFloat {
        get {
            return self.navigationController?.navigationBar.nk_height ?? 0
        }
    }
    
    @discardableResult public func nk_defaultTappedLeftBarButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @discardableResult public func nk_setTintColor(_ color: UIColor) -> UIViewController {
        self.navigationController?.navigationBar.tintColor = color
        return self
    }
    
    @discardableResult public func nk_setBarTintColor(_ color: UIColor) -> UIViewController {
        let transparent = (color == UIColor.clear)
        self.navigationController?.navigationBar.isTranslucent = transparent
        self.navigationController?.navigationBar.isUserInteractionEnabled = !transparent
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        return self
    }
    
    @discardableResult public func nk_setBackBarButton(
        text: String = "", color: UIColor? = nil) -> UIViewController {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: text, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        if color != nil {
            self.navigationController?.navigationBar.tintColor = color
        }
        
        return self
    }
    
    @discardableResult private func setupHandleGestureForLeftButtonIfNeed(enablePopGesture: Bool) {
        if enablePopGesture && self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) != nil {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            if self.nk_gestureRecognizerDelegate == nil {
                self.nk_gestureRecognizerDelegate = NKGestureRecognizerDelegate()
            }
            
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self.nk_gestureRecognizerDelegate
        }
    }
    
    @discardableResult public func nk_setLeftBarButton(_ text: String,
                                    color: UIColor = UIColor.black,
                                    highlightColor: UIColor = UIColor.lightGray,
                                    font: UIFont = UIFont.systemFont(ofSize: 14),
                                    selector: Selector = #selector(UIViewController.nk_defaultTappedLeftBarButton),
                                    enablePopGesture: Bool = true) -> UIViewController {
        let textAttributes = [NSForegroundColorAttributeName : color,
                              NSFontAttributeName : font]
        let highlightTextAttributes = [NSForegroundColorAttributeName : highlightColor,
                                       NSFontAttributeName : font]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: text,
                                                                style: UIBarButtonItemStyle.plain,
                                                                target: self,
                                                                action: selector)
        
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(textAttributes, for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(highlightTextAttributes, for: UIControlState.highlighted)
        
        
        self.setupHandleGestureForLeftButtonIfNeed(enablePopGesture: enablePopGesture)
        
        return self
    }
    
    @discardableResult public func nk_setLeftBarButton(_ image: UIImage?,
                                    selector: Selector = #selector(UIViewController.nk_defaultTappedLeftBarButton),
                                    enablePopGesture: Bool = true) -> UIViewController {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: selector)
        self.setupHandleGestureForLeftButtonIfNeed(enablePopGesture: enablePopGesture)
        return self
    }
    
    @discardableResult public func nk_setLeftBarButtons(_ image: UIImage?, otherItems: [UIBarButtonItem],
                                     selector: Selector = #selector(UIViewController.nk_defaultTappedLeftBarButton),
                                     enablePopGesture: Bool = true) -> UIViewController {
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: selector)] + otherItems
        
        self.setupHandleGestureForLeftButtonIfNeed(enablePopGesture: enablePopGesture)
        
        return self
    }
    
    @discardableResult public func nk_setLeftBarButtons(actionTitleButtons: [ActionTitleButton]) -> UIViewController {
        
        self.navigationItem.setLeftBarButtonItems(actionTitleButtons.map {UIBarButtonItem.nk_create(with: $0)}, animated: false)
        
        return self
    }
    
    @discardableResult public func nk_setRightBarButton(_ text: String,
                                     color: UIColor = UIColor.black,
                                     highlightColor: UIColor = UIColor.lightGray,
                                     font: UIFont = UIFont.systemFont(ofSize: 14),
                                     selector: Selector) -> UIViewController {
        let textAttributes = [NSForegroundColorAttributeName : color,
                              NSFontAttributeName : font]
        
        let highlightTextAttributes = [NSForegroundColorAttributeName : highlightColor,
                                       NSFontAttributeName : font]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: text,
                                                                 style: UIBarButtonItemStyle.plain,
                                                                 target: self,
                                                                 action: selector)
        
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(highlightTextAttributes, for: UIControlState.highlighted)
        
        
        return self
    }
    
    @discardableResult public func nk_setRightBarButton(image: UIImage, selector: Selector) -> UIViewController {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: selector)
        
        return self
    }
    
    @discardableResult public func nk_setRightBarButtons(actionImageButtons: [ActionImageButton], animated: Bool = false) -> UIViewController {
        var buttons = [UIBarButtonItem]()
        
        actionImageButtons.forEach({
            buttons.append(UIBarButtonItem.nk_create(with: $0))
        })
        
        self.navigationItem.setRightBarButtonItems(buttons, animated: animated)
        
        return self
    }
    
    @discardableResult public func nk_setRightBarButtons(actionTitleButtons: [ActionTitleButton]) -> UIViewController {
        
        self.navigationItem.setRightBarButtonItems(actionTitleButtons.map {UIBarButtonItem.nk_create(with: $0)}, animated: false)
        
        return self
    }
    
    @discardableResult public func nk_setRightBarButton(system: UIBarButtonSystemItem, selector: Selector) -> UIViewController {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: selector)
        return self
    }
    
    @discardableResult public func nk_setTitleBarButtonStyle(              color: UIColor = UIColor.black,
                                                        font: UIFont = UIFont.systemFont(ofSize: 14)) -> UIViewController {
        let textAttributes = [NSForegroundColorAttributeName : color,
                              NSFontAttributeName : font]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        return self
    }
    
    @discardableResult public func nk_setTitleBarButton(text: String = "",
                                     color: UIColor = UIColor.black,
                                     font: UIFont = UIFont.systemFont(ofSize: 14)) -> UIViewController {
        self.navigationItem.title = text
        self.nk_setTitleBarButtonStyle(color: color, font: font)
        return self
    }
    
    @discardableResult public func nk_transparentBar(keepLineBreak: Bool = false) -> UIViewController {
        self.navigationController?.navigationBar.nk_transparentBar(keepLineBreak: keepLineBreak)
        
        return self
    }
    
    @discardableResult public func nk_removeTransparentBar() -> UIViewController {
        self.navigationController?.navigationBar.nk_removeTransparentBar()
        
        return self
    }
    
    @discardableResult public func nk_setTitle(title: String, color: UIColor, font: UIFont) -> UIViewController {
        self.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName: color]
        
        return self
    }
    
    @discardableResult public func nk_setLineBarColor(lineWith: Double = 0.5,
                                            color: UIColor = UIColor.black) -> UIViewController {
        self.navigationController?.navigationBar.nk_setLineBarColor(lineWith: lineWith, color: color)
        
        return self
    }
    
    @discardableResult public func nk_turnStatusBarLight(on: Bool) -> UIViewController {
        UIApplication.shared.setStatusBarStyle(on ? .lightContent : .default, animated: false)
        return self
    }
}

import ObjectiveC

var NKLAssociatedBorderViewHandle: UInt8 = 0

public extension UINavigationBar {
    
    public var nk_borderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &NKLAssociatedBorderViewHandle) as? UIView
        }
        
        set {
            objc_setAssociatedObject(self, &NKLAssociatedBorderViewHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    @discardableResult public func nk_transparentBar(keepLineBreak: Bool = false) -> UINavigationBar {
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.isTranslucent = true
        
        if (!keepLineBreak) {
            self.shadowImage = UIImage()
        }
        
        self.backgroundColor = UIColor.clear
        
        return self
    }
    
    @discardableResult public func nk_removeTransparentBar() -> UINavigationBar {
        self.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.isTranslucent = false
        return self
    }
    
    @discardableResult public func nk_setLineBarColor(lineWith: Double = 0.5,
                                            color: UIColor = UIColor.black) -> UINavigationBar {
        
        self.nk_borderView?.removeFromSuperview()
        
        self.nk_borderView = UIView(frame: CGRect(x: 0,
                                                  y: self.nk_height - CGFloat(lineWith),
                                                  width: UIScreen.main.bounds.size.width,
                                                  height: 1))
        self.nk_borderView?.backgroundColor = color
        self.addSubview(self.nk_borderView!)
        
        return self
    }
    
    @discardableResult public func nk_turnStatusBarLight(on: Bool) -> UINavigationBar {
        self.barStyle = on ? .black : .default
        
        return self
    }
}

public extension UINavigationController {
    @discardableResult public func nk_resetToViewController(type: UIViewController.Type, animated: Bool = false) -> Bool {
        
        while self.viewControllers.count >= 2 && self.viewControllers.last?.isKind(of: type) == false {
            if self.viewControllers[self.viewControllers.count - 2].isKind(of:
                type) == true {
                self.popViewController(animated: animated)
                return true
            } else {
                self.popViewController(animated: false)
            }
        }
        
        return false
    }
    
    @discardableResult public func nk_removeViewControllers(types: [UIViewController.Type], animated: Bool = false, completion: (() -> ())? = nil) -> UINavigationController {
        while self.viewControllers.count > 1 && types.filter({self.viewControllers.last?.isKind(of: $0) == true}).count > 0 {
            if types.filter({self.viewControllers[self.viewControllers.count - 2].isKind(of: $0) == true}).count < 1 {
                self.popViewController(animated: animated)
                completion?()
                return self
            } else {
                self.popViewController(animated: false)
            }
        }
        
        completion?()
        return self
    }
}
