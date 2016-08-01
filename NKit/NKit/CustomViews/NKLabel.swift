//
//  NKLabel.swift
//  FastSell
//
//  Created by Nghia Nguyen on 6/18/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import UIKit

public class NKLabel: UILabel {
    public var nk_edgeInsets: UIEdgeInsets?
    
    public override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)
        
        rect.origin.y = self.bounds.origin.y
        return rect
        
    }
    
    public override func drawTextInRect(rect: CGRect) {
        var actualRect = self.textRectForBounds(rect, limitedToNumberOfLines: self.numberOfLines)
        
        if let height = self.text?.heightWithWidth(self.nk_width, font: self.font) where actualRect.size.height < height {
           actualRect.size.height = height
        }
        
        return super.drawTextInRect(actualRect)
    }
}

