//
//  NKLabel.swift
//  FastSell
//
//  Created by Nghia Nguyen on 6/18/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import UIKit

open class NKLabel: UILabel {
    open var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    open var fitBounds: Bool = false
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        if self.fitBounds {
            rect.origin.y = self.bounds.origin.y
        }
        return rect
        
    }
    
    open override func drawText(in rect: CGRect) {
        var actualRect = rect
        
        if self.fitBounds {
            actualRect = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
            
            let height = self.nk_heightWithWidth(width: self.nk_width)
            if  actualRect.size.height < height {
                actualRect.size.height = height
            }
        }
        
        return super.drawText(in: UIEdgeInsetsInsetRect(actualRect, self.edgeInsets))
    }
    
    open override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += self.edgeInsets.left + self.edgeInsets.right
        contentSize.height += self.edgeInsets.top + self.edgeInsets.bottom
        return contentSize
    }
}

