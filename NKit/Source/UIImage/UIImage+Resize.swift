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
    
    public func nk_resizeIfOutMaxSize(_ maxSize: CGSize, scale: CGFloat = 0) -> UIImage {
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
        
        return self.nk_resizeAspectFillToSize(CGSize(width: width, height: height), scale: scale)
    }
    
    public func nk_resizeToSize(_ dstSize: CGSize, scale: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(dstSize, false, scale)
        self.draw(in: CGRect(x: 0, y: 0, width: dstSize.width, height: dstSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    public func nk_resizeAspectFitToSize(_ dstSize: CGSize, scale: CGFloat = 0) -> UIImage {
        let hightScale = dstSize.height / self.size.height
        let widthScale = dstSize.width / self.size.width
        let sizeScale = min(hightScale, widthScale)
        
        let aspectSize = CGSize(width: self.size.width * sizeScale, height: self.size.height * sizeScale)
        return self.nk_resizeToSize(aspectSize, scale: scale)
    }
    
    public func nk_resizeAspectFillToSize(_ dstSize: CGSize, scale: CGFloat = 0) -> UIImage {
        let hightScale = dstSize.height / self.size.height
        let widthScale = dstSize.width / self.size.width
        let sizeScale = max(hightScale, widthScale)
        
        let aspectSize = CGSize(width: self.size.width * sizeScale, height: self.size.height * sizeScale)
        
        return self.nk_resizeToSize(aspectSize, scale: scale).nk_cropToSize(dstSize)
    }
    
    public func nk_cropToSize(_ dstSize: CGSize) -> UIImage {
        let startPointX = self.size.width / 2 - dstSize.width / 2
        let startPointY = self.size.height / 2 - dstSize.height / 2
        guard startPointX >= 0 && startPointY >= 0 else {
            return self
        }
        
        if let cgImage = self.cgImage!.cropping(to: CGRect(x: startPointX * self.scale, y: startPointY * self.scale, width: dstSize.width * self.scale, height: dstSize.height * self.scale)) {
            return UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
        }
        
        return self
    }
    
    public func nk_scaleWithRatio(_ ratio: CGFloat, scale: CGFloat = 0) -> UIImage {
        let newSize: CGSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        
        return self.nk_resizeToSize(newSize, scale: scale)
    }
    
    public var nk_rotatePortrait: UIImage {
        let imgRef = self.cgImage
        let imageSource = self
        
        let width = CGFloat(imgRef!.width)
        let height = CGFloat(imgRef!.height)
        
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let scaleRatio : CGFloat = 1
        
        var transform = CGAffineTransform.identity
        let orient = imageSource.imageOrientation
        let imageSize = CGSize(width: CGFloat(imgRef!.width), height: CGFloat(imgRef!.height))
        
        
        switch(imageSource.imageOrientation) {
        case .up :
            transform = CGAffineTransform.identity
            
        case .upMirrored :
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            
        case .down :
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            
        case .downMirrored :
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height)
            transform = transform.scaledBy(x: 1.0, y: -1.0)
            
        case .left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width)
            transform = transform.rotated(by: 3.0 * CGFloat(M_PI) / 2.0)
            
        case .leftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            transform = transform.rotated(by: 3.0 * CGFloat(M_PI) / 2.0)
            
        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0)
            transform = transform.rotated(by: CGFloat(M_PI) / 2.0)
            
        case .rightMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = transform.rotated(by: CGFloat(M_PI) / 2.0)
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        
        if orient == .right || orient == .left {
            context.scaleBy(x: -scaleRatio, y: scaleRatio)
            context.translateBy(x: -height, y: 0)
        } else {
            context.scaleBy(x: scaleRatio, y: -scaleRatio)
            context.translateBy(x: 0, y: -height)
        }
        
        context.concatenate(transform)
        if let imgRef = imgRef {
            context.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageCopy!
    }
}
