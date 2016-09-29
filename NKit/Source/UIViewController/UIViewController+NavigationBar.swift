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
    
    public func nk_defaultTappedLeftBarButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    public func nk_setTintColor(color: UIColor) -> UIViewController {
        self.navigationController?.navigationBar.tintColor = color
        return self
    }
    
    public func nk_setBarTintColor(color: UIColor) -> UIViewController {
        let transparent = (color == UIColor.clearColor())
        self.navigationController?.navigationBar.translucent = transparent
        self.navigationController?.navigationBar.userInteractionEnabled = !transparent
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        return self
    }
    
    public func nk_setBackBarButton(text text: String = "", color: UIColor? = nil) -> UIViewController {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: text, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        if color != nil {
            self.navigationController?.navigationBar.tintColor = color
        }
        
        return self
    }
    
    private func setupHandleGestureForLeftButtonIfNeed(enablePopGesture: Bool) {
        if enablePopGesture && self.navigationController?.respondsToSelector(Selector("interactivePopGestureRecognizer")) != nil {
            self.navigationController?.interactivePopGestureRecognizer?.enabled = true
            if self.nk_gestureRecognizerDelegate == nil {
                self.nk_gestureRecognizerDelegate = NKGestureRecognizerDelegate()
            }
            
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self.nk_gestureRecognizerDelegate
        }
    }
    
    public func nk_setLeftBarButton(text: String,
                                    color: UIColor = UIColor.blackColor(),
                                    highlightColor: UIColor = UIColor.lightGrayColor(),
                                    font: UIFont = UIFont.systemFontOfSize(14),
                                    selector: Selector = #selector(UIViewController.nk_defaultTappedLeftBarButton),
                                    enablePopGesture: Bool = true) -> UIViewController {
        let textAttributes = [NSForegroundColorAttributeName : color,
                              NSFontAttributeName : font]
        let highlightTextAttributes = [NSForegroundColorAttributeName : highlightColor,
                                       NSFontAttributeName : font]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: text,
                                                                style: UIBarButtonItemStyle.Plain,
                                                                target: self,
                                                                action: selector)
        
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(textAttributes, forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(highlightTextAttributes, forState: UIControlState.Highlighted)
        
        self.setupHandleGestureForLeftButtonIfNeed(enablePopGesture)
        
        return self
    }
    
    public func nk_setLeftBarButton(image: UIImage?,
                                    selector: Selector = #selector(UIViewController.nk_defaultTappedLeftBarButton),
                                    enablePopGesture: Bool = true) -> UIViewController {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: selector)
        self.setupHandleGestureForLeftButtonIfNeed(enablePopGesture)
        return self
    }
    
    public func nk_setLeftBarButtons(image: UIImage?, otherItems: [UIBarButtonItem],
                                     selector: Selector = #selector(UIViewController.nk_defaultTappedLeftBarButton),
                                     enablePopGesture: Bool = true) -> UIViewController {
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: selector)] + otherItems
        
        self.setupHandleGestureForLeftButtonIfNeed(enablePopGesture)
        
        return self
    }
    
    public func nk_setRightBarButton(text: String,
                                     color: UIColor = UIColor.blackColor(),
                                     highlightColor: UIColor = UIColor.lightGrayColor(),
                                     font: UIFont = UIFont.systemFontOfSize(14),
                                     selector: Selector) -> UIViewController {
        let textAttributes = [NSForegroundColorAttributeName : color,
                              NSFontAttributeName : font]
        
        let highlightTextAttributes = [NSForegroundColorAttributeName : highlightColor,
                                       NSFontAttributeName : font]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: text,
                                                                 style: UIBarButtonItemStyle.Plain,
                                                                 target: self,
                                                                 action: selector)
        
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(highlightTextAttributes, forState: UIControlState.Highlighted)
        
        return self
    }
    
    public func nk_setRightBarButton(image: UIImage, selector: Selector) -> UIViewController {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: selector)
        
        return self
    }
    
    typealias ActionImageButton = (image: UIImage, selector: Selector)
    public func nk_setRightBarButtons(actionImageButtons: [ActionImageButton], animated: Bool = false) -> UIViewController {
        var buttons = [UIBarButtonItem]()
        
        actionImageButtons.forEach({
            buttons.append(UIBarButtonItem(image: $0.image, style: UIBarButtonItemStyle.Plain, target: self, action: $0.selector))
        })
        
        self.navigationItem.setRightBarButtonItems(buttons, animated: animated)
        
        return self
    }
    typealias ActionTitleButton = (title: String, font: UIFont, selector: Selector)
    public func nk_setRightBarButtons(actionTitleButtons: [ActionTitleButton]) -> UIViewController {
        var buttons = [UIBarButtonItem]()
        
        actionTitleButtons.forEach({
            let textAttributes = [NSFontAttributeName: $0.font]
            let buttonItem = UIBarButtonItem(title: $0.title, style: .Plain, target: self, action: $0.selector)
            buttonItem.setTitleTextAttributes(textAttributes, forState: .Normal)
            buttons.append(buttonItem)
        })
        
        self.navigationItem.setRightBarButtonItems(buttons, animated: false)
        
        return self
    }
    
    public func nk_setRightBarButton(system system: UIBarButtonSystemItem, selector: Selector) -> UIViewController {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: selector)
        return self
    }
    
    public func nk_setTitleBarButton(text: String = "",
                                     color: UIColor = UIColor.blackColor(),
                                     font: UIFont = UIFont.systemFontOfSize(14)) -> UIViewController {
        let textAttributes = [NSForegroundColorAttributeName : color,
                              NSFontAttributeName : font]
        self.navigationItem.title = text
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        return self
    }
    
    public func nk_transparentBar(keepLineBreak: Bool = false) -> UIViewController {
        self.navigationController?.navigationBar.nk_transparentBar(keepLineBreak)
        
        return self
    }
    
    public func nk_removeTransparentBar() -> UIViewController {
        self.navigationController?.navigationBar.nk_removeTransparentBar()
        
        return self
    }
    
    public func nk_setTitle(title: String, color: UIColor, font: UIFont) -> UIViewController {
        self.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName: color]
        
        return self
    }
    
    public func nk_setLineBarColor(lineWith lineWith: Double = 0.5,
                                            color: UIColor = UIColor.blackColor()) -> UIViewController {
        self.navigationController?.navigationBar.nk_setLineBarColor(lineWith: lineWith, color: color)
        
        return self
    }
    
    public func nk_turnStatusBarLight(on: Bool) -> UIViewController {
        UIApplication.sharedApplication().setStatusBarStyle(on ? .LightContent : .Default, animated: false)
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
    
    
    
    public func nk_transparentBar(keepLineBreak: Bool = false) -> UINavigationBar {
        self.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.translucent = true
        
        if (!keepLineBreak) {
            self.shadowImage = UIImage()
        }
        
        self.backgroundColor = UIColor.clearColor()
        
        return self
    }
    
    public func nk_removeTransparentBar() -> UINavigationBar {
        self.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.translucent = false
        return self
    }
    
    public func nk_setLineBarColor(lineWith lineWith: Double = 0.5,
                                            color: UIColor = UIColor.blackColor()) -> UINavigationBar {
        
        self.nk_borderView?.removeFromSuperview()
        
        self.nk_borderView = UIView(frame: CGRectMake(0, self.nk_height - CGFloat(lineWith),
            UIScreen.mainScreen().bounds.size.width, 1))
        self.nk_borderView?.backgroundColor = color
        self.addSubview(self.nk_borderView!)
        
        return self
    }
    
    public func nk_turnStatusBarLight(on: Bool) -> UINavigationBar {
        self.barStyle = on ? .Black : .Default
        
        return self
    }
}

public extension UINavigationController {
    public func nk_resetToViewController(type: UIViewController.Type, animated: Bool = false) -> Bool {
        
        while self.viewControllers.count >= 2 && self.viewControllers.last?.isKindOfClass(type) == false {
            if self.viewControllers[self.viewControllers.count - 2].isKindOfClass(type) == true {
                self.popViewControllerAnimated(animated)
                return true
            } else {
                self.popViewControllerAnimated(false)
            }
        }
        
        return false
    }
    
    public func nk_removeViewControllers(types: [UIViewController.Type], animated: Bool = false, completion: (() -> ())? = nil) -> UINavigationController {
        while self.viewControllers.count > 1 && types.filter({self.viewControllers.last?.isKindOfClass($0) == true}).count > 0 {
            if types.filter({self.viewControllers[self.viewControllers.count - 2].isKindOfClass($0) == true}).count < 1 {
                self.popViewControllerAnimated(animated)
                completion?()
                return self
            } else {
                self.popViewControllerAnimated(false)
            }
        }
        
        completion?()
        return self
    }
}
