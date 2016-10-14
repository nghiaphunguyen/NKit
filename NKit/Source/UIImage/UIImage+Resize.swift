//
//  UIImage+Resize.m
//
//  Created by Olivier Halligon on 12/08/09.
//  Copyright 2009 AliSoftware. All rights reserved.
//
import UIKit

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
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
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
        
        if let cgImage = CGImageCreateWithImageInRect(self.CGImage!, CGRectMake(startPointX * self.scale, startPointY * self.scale, dstSize.width * self.scale, dstSize.height * self.scale)) {
            return UIImage(CGImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
        }
        
        return self
    }
    
    public func nk_scaleWithRatio(ratio: CGFloat, scale: CGFloat = 0) -> UIImage {
        let newSize: CGSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio)
        
        return self.nk_resizeToSize(newSize, scale: scale)
    }
    
    public var nk_rotatePortrait: UIImage {
            let imgRef = self.CGImage
            let imageSource = self
            
            let width = CGFloat(CGImageGetWidth(imgRef!))
            let height = CGFloat(CGImageGetHeight(imgRef!))
            
            var bounds = CGRectMake(0, 0, width, height)
            
            let scaleRatio : CGFloat = 1
            
            var transform = CGAffineTransformIdentity
            let orient = imageSource.imageOrientation
            let imageSize = CGSizeMake(CGFloat(CGImageGetWidth(imgRef!)), CGFloat(CGImageGetHeight(imgRef!)))
            
            
            switch(imageSource.imageOrientation) {
            case .Up :
                transform = CGAffineTransformIdentity
                
            case .UpMirrored :
                transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0)
                transform = CGAffineTransformScale(transform, -1.0, 1.0)
                
            case .Down :
                transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
                
            case .DownMirrored :
                transform = CGAffineTransformMakeTranslation(0.0, imageSize.height)
                transform = CGAffineTransformScale(transform, 1.0, -1.0)
                
            case .Left :
                let storedHeight = bounds.size.height
                bounds.size.height = bounds.size.width
                bounds.size.width = storedHeight
                transform = CGAffineTransformMakeTranslation(0.0, imageSize.width)
                transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0)
                
            case .LeftMirrored :
                let storedHeight = bounds.size.height
                bounds.size.height = bounds.size.width
                bounds.size.width = storedHeight
                transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width)
                transform = CGAffineTransformScale(transform, -1.0, 1.0)
                transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0)
                
            case .Right :
                let storedHeight = bounds.size.height
                bounds.size.height = bounds.size.width
                bounds.size.width = storedHeight
                transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0)
                
            case .RightMirrored :
                let storedHeight = bounds.size.height
                bounds.size.height = bounds.size.width
                bounds.size.width = storedHeight
                transform = CGAffineTransformMakeScale(-1.0, 1.0)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0)
            }
            
            UIGraphicsBeginImageContext(bounds.size)
            let context = UIGraphicsGetCurrentContext()
            
            if orient == .Right || orient == .Left {
                CGContextScaleCTM(context!, -scaleRatio, scaleRatio)
                CGContextTranslateCTM(context!, -height, 0)
            } else {
                CGContextScaleCTM(context!, scaleRatio, -scaleRatio)
                CGContextTranslateCTM(context!, 0, -height)
            }
            
            CGContextConcatCTM(context!, transform)
            CGContextDrawImage(UIGraphicsGetCurrentContext()!, CGRectMake(0, 0, width, height), imgRef!)
            
            let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return imageCopy!
        }
}
