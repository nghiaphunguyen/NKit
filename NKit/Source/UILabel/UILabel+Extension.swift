//
//  UILabel+Extension.swift
//
//  Created by Nghia Nguyen on 12/3/15.
//

import UIKit

public extension UILabel {
    public convenience init(text: String?,
        font: UIFont = UIFont.systemFontOfSize(14),
        color: UIColor = UIColor.blackColor(),
        isSizeToFit: Bool = true,
        alignment: NSTextAlignment = .Left) {
            self.init(frame: CGRectZero)
            self.font = font
            self.textColor = color
            self.textAlignment = alignment
            self.text = text
            if isSizeToFit {
                self.sizeToFit()
            }
    }
}


public extension UILabel {
    public func nk_heightWithWidth(width: CGFloat) -> CGFloat {
        guard let text = text else {
            return 0
        }
        return text.nk_heightWithWidth(width, font: font)
    }
    
    public func nk_heightWithAttributedWidth(width: CGFloat) -> CGFloat {
        guard let attributedText = attributedText else {
            return 0
        }
        return attributedText.nk_heightWithWidth(width)
    }
}