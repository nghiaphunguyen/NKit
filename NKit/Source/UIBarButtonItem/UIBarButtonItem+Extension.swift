//
//  UIBarButtonItem+Extension.swift
//  FastSell
//
//  Created by Nghia Nguyen on 5/30/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import UIKit

public struct ActionTitleButton {
    let title: String
    let color: UIColor
    let font: UIFont
    let target: Any?
    let selector: Selector?
    
    public init(title: String, color: UIColor, font: UIFont, target: Any?, selector: Selector?) {
        self.title = title
        self.color = color
        self.font = font
        self.target = target
        self.selector = selector
    }
}

public struct ActionImageButton {
    let image: UIImage
    let target: Any?
    let selector: Selector?
    
    public init(image: UIImage, target: Any?, selector: Selector?) {
        self.image = image
        self.target = target
        self.selector = selector
    }
}

public extension UIBarButtonItem {
    public var nk_view: UIView? {
        return self.value(forKeyPath: "view") as? UIView
    }
    
    public static func nk_create(with actionTitleButton: ActionTitleButton) -> UIBarButtonItem {
        let textAttributes = [NSAttributedString.Key.font: actionTitleButton.font, NSAttributedString.Key.foregroundColor: actionTitleButton.color]
        let buttonItem = UIBarButtonItem(title: actionTitleButton.title, style: .plain, target: actionTitleButton.target, action: actionTitleButton.selector)
        buttonItem.setTitleTextAttributes(textAttributes, for: .normal)
        return buttonItem
    }
    
    public static func nk_create(with actionImageButton: ActionImageButton) -> UIBarButtonItem {
        return UIBarButtonItem(image: actionImageButton.image, style: UIBarButtonItem.Style.plain, target: actionImageButton.target, action: actionImageButton.selector)
    }
}



