//
//  NKBaseCollectionViewCell.swift
//  FastSell
//
//  Created by Nghia Nguyen on 5/21/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
}

public class NKBaseCollectionViewCell: UICollectionViewCell {
    var autoFitDimension: NKDimension? = nil
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupView()
    }
    
    public func setupView() {}
    
    public override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let autoFitDimension = self.autoFitDimension else {
            return layoutAttributes
        }
        
        let attributes = super.preferredLayoutAttributesFittingAttributes(layoutAttributes)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let size = self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        var newFrame = layoutAttributes.frame
        if autoFitDimension.contains(NKDimension.Width) {
            newFrame.size.width = size.width
        }
        
        if autoFitDimension.contains(NKDimension.Height) {
            newFrame.size.height = size.height
        }
        
        attributes.frame = newFrame
        return attributes
    }
}
