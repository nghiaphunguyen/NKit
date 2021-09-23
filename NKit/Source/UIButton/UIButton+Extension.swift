//
//  UIButton+Extension.swift
//
//  Created by Nghia Nguyen on 12/3/15.
//

import UIKit

//MARK: Constructors
public extension UIButton {
    public convenience init(title: String,
        textFont: UIFont = UIFont.systemFont(ofSize: 14),
        textColor: UIColor = UIColor.black,
        backgroundColor: UIColor? = nil,
        highlightColor: UIColor? = nil,
        cornerRadius: CGFloat = 0,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = UIColor.black) {
            self.init(frame: CGRect.zero)
            
            self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: UIControl.State.normal)
            self.titleLabel?.font = textFont
            
            if let bg = backgroundColor {
                self.backgroundColor = bg
            }
            
            if let hi = highlightColor {
                self.setBackgroundImage(UIImage.nk_fromColor(hi, size: CGSizeMake(1, 1)),
                    for: .highlighted)
            }
            
            _ = self.nk_addBorder(borderWidth: borderWidth, color: borderColor, cornerRadius: cornerRadius)
    }
    
    public convenience init(image: UIImage,
        highlightImage: UIImage) {
        self.init(frame: CGRect.zero)
        
        self.setImage(image, for: .normal)
        self.setImage(highlightImage, for: .highlighted)
    }
    
    public convenience init(title: String,
        textFont: UIFont,
        textColorNormal: UIColor,
        textColorSelected: UIColor,
        normalImage: UIImage,
        selectedImage: UIImage,
        highlightColor: UIColor? = nil) {
            self.init(frame: CGRect.zero)
            
        self.setImage(normalImage, for: UIControl.State.normal)
            self.setImage(selectedImage, for: .selected)
            if highlightColor != nil {
                self.setBackgroundImage(UIImage.nk_fromColor(highlightColor!, size: CGSizeMake(1, 1)), for: UIControl.State.highlighted)
            }
            
            self.setTitle(title, for: .normal)
            self.setTitleColor(textColorNormal, for: .normal)
            self.setTitleColor(textColorSelected, for: .selected)
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
