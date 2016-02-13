//
//  UILabel+Extension.swift
//
//  Created by Nghia Nguyen on 12/3/15.
//

import UIKit

public extension UILabel {
    public convenience init(text: String,
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
