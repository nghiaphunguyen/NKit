//
//  UILabel+Extension.swift
//
//  Created by Nghia Nguyen on 12/3/15.
//

import UIKit

public extension UILabel {
    public convenience init(text: String?,
        font: UIFont = UIFont.systemFont(ofSize: 14),
        color: UIColor = UIColor.black,
        isSizeToFit: Bool = true,
        alignment: NSTextAlignment = .left) {
            self.init(frame: CGRect.zero)
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
        return text.nk_heightWithWidth(width: width, font: font)
    }
    
    public func nk_heightWithAttributedWidth(width: CGFloat) -> CGFloat {
        guard let attributedText = attributedText else {
            return 0
        }
        return attributedText.nk_heightWithWidth(width: width)
    }
}
