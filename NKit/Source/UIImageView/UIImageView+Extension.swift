//
//  UIImageView+Extension.swift
//
//  Created by Nghia Nguyen on 12/3/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit

//MARK: Properties
public extension UIImageView {
    public var nk_imageWidth: CGFloat {
        get {
            return self.image?.size.width ?? 0
        }
    }
    
    public var nk_imageHeight: CGFloat {
        get {
            return self.image?.size.height ?? 0
        }
    }
    
    public var nk_imageSize: CGSize {
        get {
            return CGSize(width: self.nk_imageWidth, height: self.nk_imageHeight)
        }
    }
}
