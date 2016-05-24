//
//  UIImage+Resize.m
//
//  Created by Olivier Halligon on 12/08/09.
//  Copyright 2009 AliSoftware. All rights reserved.
//
public extension UIImage {
    
    public var nk_square: UIImage {
        let edge = min(self.size.width, self.size.height)
        return self.nk_cropToSize(CGSize(width: edge, height: edge))
    }
    
    public func nk_resizeIfOutMaxSize(maxSize: CGSize, scale: CGFloat = 0) -> UIImage {
        if self.size.width <= maxSize.width && self.size.height <= maxSize.height {
            return self
        }
        
        var width = self.size.width
        var height = self.size.height
        
        if width > maxSize.width {
            height = height * maxSize.width / width
            width = maxSize.width
        }
        
        if height > maxSize.height {
            width = width * maxSize.height / height
            height = maxSize.height
        }
        
        return self.nk_resizeAspectFillToSize(CGSizeMake(width, height), scale: scale)
    }
    
    public func nk_resizeToSize(dstSize: CGSize, scale: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(dstSize, false, scale)
        self.drawInRect(CGRectMake(0, 0, dstSize.width, dstSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    public func nk_resizeAspectFitToSize(dstSize: CGSize, scale: CGFloat = 0) -> UIImage {
        let hightScale = dstSize.height / self.size.height
        let widthScale = dstSize.width / self.size.width
        let sizeScale = min(hightScale, widthScale)
        
        let aspectSize = CGSizeMake(self.size.width * sizeScale, self.size.height * sizeScale)
        return self.nk_resizeToSize(aspectSize, scale: scale)
    }
    
    public func nk_resizeAspectFillToSize(dstSize: CGSize, scale: CGFloat = 0) -> UIImage {
        let hightScale = dstSize.height / self.size.height
        let widthScale = dstSize.width / self.size.width
        let sizeScale = max(hightScale, widthScale)
        
        let aspectSize = CGSizeMake(self.size.width * sizeScale, self.size.height * sizeScale)
        
        return self.nk_resizeToSize(aspectSize, scale: scale).nk_cropToSize(dstSize)
    }
    
    public func nk_cropToSize(dstSize: CGSize) -> UIImage {
        let startPointX = self.size.width / 2 - dstSize.width / 2
        let startPointY = self.size.height / 2 - dstSize.height / 2
        guard startPointX >= 0 && startPointY >= 0 else {
            return self
        }
        
        if let cgImage = CGImageCreateWithImageInRect(self.CGImage, CGRectMake(startPointX * self.scale, startPointY * self.scale, dstSize.width * self.scale, dstSize.height * self.scale)) {
            return UIImage(CGImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
        }
        
        return self
    }
    
    public func nk_scaleWithRatio(ratio: CGFloat, scale: CGFloat = 0) -> UIImage {
        let newSize: CGSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio)
        
        return self.nk_resizeToSize(newSize, scale: scale)
    }
}