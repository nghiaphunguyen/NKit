//
//  UIView+NavigationBar.swift
//
//  Created by Nghia Nguyen on 11/22/15.
//

import UIKit

public extension UIViewController {
    
    public static var kNKNavigationBarFontSize: CGFloat {
        get {
            return 17
        }
    }
    
    public var nk_navigationBarHeight: CGFloat {
        get {
            return self.navigationController?.navigationBar.nk_height ?? 0
        }
    }
    
    public func nk_hideBackBarButton() -> UIViewController {
        self.navigationItem.hidesBackButton = true
        
        return self
    }
    
    public func nk_setBackBarButton(text text: String = "", color: UIColor? = nil) -> UIViewController {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: text, style: UIBarButtonItemStyle.Plain, target: nil, action: "")
        
        if color != nil {
            self.navigationController?.navigationBar.tintColor = color
        }
        
        return self
    }
    
    public func nk_setLeftBarButton(text: String,
        color: UIColor = UIColor.blackColor(),
        highlightColor: UIColor = UIColor.lightGrayColor(),
        font: UIFont = UIFont.systemFontOfSize(UIViewController.kNKNavigationBarFontSize),
        selector: Selector,
        likeBackButton: Bool = false) -> UIViewController {
            self.navigationItem.hidesBackButton = true
            
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
            
            if likeBackButton
                && self.navigationController?.respondsToSelector("interactivePopGestureRecognizer") != nil {
                    self.navigationController?.interactivePopGestureRecognizer?.enabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.delegate = (self as! UIGestureRecognizerDelegate)
                    // TODO: figure out way to add recognizer touch gesture
            }
            
            return self
    }
    
    public func nk_setLeftBarButton(image: UIImage?,
        selector: Selector,
        likeBackButton: Bool = false) -> UIViewController {
            
            self.navigationItem.hidesBackButton = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: selector)
            
            if likeBackButton
                && self.navigationController?.respondsToSelector("interactivePopGestureRecognizer") != nil {
                    self.navigationController?.interactivePopGestureRecognizer?.enabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.delegate = (self as! UIGestureRecognizerDelegate)
                    // TODO: figure out way to add recognizer touch gesture
            }
            
            return self
    }
    
    public func nk_setRightBarButton(text: String,
        color: UIColor = UIColor.blackColor(),
        highlightColor: UIColor = UIColor.lightGrayColor(),
        font: UIFont = UIFont.systemFontOfSize(UIViewController.kNKNavigationBarFontSize),
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
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: selector)
        
        return self
    }
    
    public func nk_setTitleBarButton(text: String = "",
        color: UIColor = UIColor.blackColor(),
        font: UIFont = UIFont.systemFontOfSize(UIViewController.kNKNavigationBarFontSize)) -> UIViewController {
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
    
    public func nk_setLineBarColor(lineWith lineWith: Double = 0.5,
        color: UIColor = UIColor.blackColor()) -> UIViewController {
        self.navigationController?.navigationBar.nk_setLineBarColor(lineWith: lineWith, color: color)
        
        return self
    }
    
    public func nk_turnStatusBarLight(on: Bool) -> UIViewController {
        self.navigationController?.navigationBar.nk_turnStatusBarLight(on)

        return self
    }
}

import ObjectiveC

var NKAssociatedBorderViewHandle: UInt8 = 0

public extension UINavigationBar {
    
    public var nk_borderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &NKAssociatedBorderViewHandle) as? UIView
        }
        
        set {
            objc_setAssociatedObject(self, &NKAssociatedBorderViewHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
