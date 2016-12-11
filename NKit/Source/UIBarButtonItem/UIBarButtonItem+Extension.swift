//
//  UIBarButtonItem+Extension.swift
//  FastSell
//
//  Created by Nghia Nguyen on 5/30/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import UIKit
public typealias ActionTitleButton = (title: String, color: UIColor, font: UIFont, selector: Selector)
public typealias ActionImageButton = (image: UIImage, selector: Selector)

public extension UIBarButtonItem {
    public var nk_view: UIView? {
        return self.value(forKeyPath: "view") as? UIView
    }
    
    public static func nk_create(with actionTitleButton: ActionTitleButton) -> UIBarButtonItem {
        let textAttributes = [NSFontAttributeName: actionTitleButton.font, NSForegroundColorAttributeName: actionTitleButton.color]
        let buttonItem = UIBarButtonItem(title: actionTitleButton.title, style: .plain, target: self, action: actionTitleButton.selector)
        buttonItem.setTitleTextAttributes(textAttributes, for: .normal)
        return buttonItem
    }
    
    public static func nk_create(with actionImageButton: ActionImageButton) -> UIBarButtonItem {
        return UIBarButtonItem(image: actionImageButton.image, style: UIBarButtonItemStyle.plain, target: self, action: actionImageButton.selector)
    }
}



