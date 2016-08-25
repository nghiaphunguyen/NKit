//
//  NKLabel.swift
//  FastSell
//
//  Created by Nghia Nguyen on 6/18/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import UIKit

public class NKLabel: UILabel {
    public var edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
    public var fitBounds: Bool = false
    
    public override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)
        
        if self.fitBounds {
            rect.origin.y = self.bounds.origin.y
        }
        return rect
        
    }
    
    public override func drawTextInRect(rect: CGRect) {
        var actualRect = rect
        
        if self.fitBounds {
            actualRect = self.textRectForBounds(rect, limitedToNumberOfLines: self.numberOfLines)
            
            let height = self.nk_heightWithWidth(self.nk_width)
            if  actualRect.size.height < height {
                actualRect.size.height = height
            }
        }
        
        return super.drawTextInRect(UIEdgeInsetsInsetRect(actualRect, self.edgeInsets))
    }
}

