//
//  NKLayoutTestable.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/23/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKLayoutTestable {
    static var viewController: UIViewController { get }
    static var shouldAddNavigationBar: Bool {get}
    static var size: CGSize {get}
    static var backgroundColor: UIColor {get}
}

public extension NKLayoutTestable where Self: UIView {
    public static var viewController: UIViewController {
        let controller = UIViewController()
        let view = self.init()
        controller.view.addSubview(view)
        controller.view.backgroundColor = self.backgroundColor
        
        if self.size == CGSize.zero {
            view.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(0).offset(nk_statusBarHeight)
                make.leading.trailing.equalTo(0)
            })
        } else {
            view.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(0).offset(nk_statusBarHeight)
                make.leading.equalTo(0)
                make.size.equalTo(self.size)
            })
        }
        
        if self.shouldAddNavigationBar {
            return UINavigationController(rootViewController: controller)
        }
        
        return controller
    }
    
    public static var size: CGSize {
        return CGSize.zero
    }
    
    public static var backgroundColor: UIColor {
        return UIColor.whiteColor()
    }
    
    public static var shouldAddNavigationBar: Bool {
        return false
    }
}

public extension NKLayoutTestable where Self: UIViewController {
    public static var viewController: UIViewController {
        
        if self.shouldAddNavigationBar {
            return UINavigationController(rootViewController: self.init())
        }
        
        return self.init()
    }
    
    public static var shouldAddNavigationBar: Bool {
        return true
    }
    
    public static var size: CGSize {
        return NKScreenSize.Current
    }
    
    public static var backgroundColor: UIColor {
        return UIColor.whiteColor()
    }
}