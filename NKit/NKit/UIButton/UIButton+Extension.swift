//
//  UIButton+Extension.swift
//
//  Created by Nghia Nguyen on 12/3/15.
//

import UIKit

//MARK: Constructors
public extension UIButton {
    public convenience init(title: String,
        textFont: UIFont = UIFont.systemFontOfSize(14),
        textColor: UIColor = UIColor.blackColor(),
        backgroundColor: UIColor? = nil,
        highlightColor: UIColor? = nil,
        cornerRadius: CGFloat = 0,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = UIColor.blackColor()) {
            self.init(frame: CGRectZero)
            
            self.setTitle(title, forState: .Normal)
            self.setTitleColor(textColor, forState: UIControlState.Normal)
            self.titleLabel?.font = textFont
            
            if let bg = backgroundColor {
                self.backgroundColor = bg
            }
            
            if let hi = highlightColor {
                self.setBackgroundImage(UIImage.nk_fromColor(hi, size: CGSizeMake(1, 1)),
                    forState: .Highlighted)
            }
            
            self.nk_addBorder(borderWidth: borderWidth, color: borderColor, cornerRadius: cornerRadius)
    }
    
    public convenience init(image: UIImage,
        highlightImage: UIImage) {
        self.init(frame: CGRectZero)
        
        self.setImage(image, forState: .Normal)
        self.setImage(highlightImage, forState: .Highlighted)
    }
    
    public convenience init(title: String,
        textFont: UIFont,
        textColorNormal: UIColor,
        textColorSelected: UIColor,
        normalImage: UIImage,
        selectedImage: UIImage,
        highlightColor: UIColor? = nil) {
            self.init(frame: CGRectZero)
            
            self.setImage(normalImage, forState: UIControlState.Normal)
            self.setImage(selectedImage, forState: UIControlState.Selected)
            if highlightColor != nil {
                self.setBackgroundImage(UIImage.nk_fromColor(highlightColor!, size: CGSizeMake(1, 1)), forState: UIControlState.Highlighted)
            }
            
            self.setTitle(title, forState: .Normal)
            self.setTitleColor(textColorNormal, forState: .Normal)
            self.setTitleColor(textColorSelected, forState: .Selected)
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.nk_imageWidth / 2, -self.nk_imageHeight / 2, 0)
    }
}

//MARK: Properties
public extension UIButton {
    public var nk_imageWidth: CGFloat {
        get {
            return self.imageView?.image?.size.width ?? 0
        }
    }
    
    public var nk_imageHeight: CGFloat {
        get {
            return self.imageView?.image?.size.height ?? 0
        }
    }
    
    public var nk_imageSize: CGSize {
        get {
            return CGSizeMake(self.nk_imageWidth, self.nk_imageHeight)
        }
    }
}
