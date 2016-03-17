//
//  UIImage+Resize.m
//
//  Created by Olivier Halligon on 12/08/09.
//  Copyright 2009 AliSoftware. All rights reserved.
//
public extension UIImage {
    public func nk_resizedImageToSize(dstSize: CGSize) -> UIImage? {
        let hightScale = dstSize.height / self.size.height
        let widthScale = dstSize.width / self.size.width
        let scale = hightScale > widthScale ? hightScale : widthScale
        
        let aspectSize = CGSizeMake(self.size.width * scale, self.size.height * scale)
        let aspectPoint = CGPointMake(dstSize.width / 2 - aspectSize.width / 2, dstSize.height / 2 - aspectSize.height / 2)
        let aspectRect = CGRectMake(aspectPoint.x, aspectPoint.y, self.size.width * scale, self.size.height * scale)
        
        UIGraphicsBeginImageContext(dstSize)
        self.drawInRect(aspectRect)
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizeImage
    }
    /////////////////////////////////////////////////////////////////////////////
    
    public func nk_resizedImageToFitInSize(boundingSize: CGSize, scaleIfSmaller scale: Bool) -> UIImage {
        var boundingSize = boundingSize
        // get the image size (independant of imageOrientation)
        let imgRef: CGImageRef = self.CGImage!
        let srcSize: CGSize = CGSizeMake(CGFloat(CGImageGetWidth(imgRef)), CGFloat(CGImageGetHeight(imgRef)))
        // not equivalent to self.size (which depends on the imageOrientation)!
        // adjust boundingSize to make it independant on imageOrientation too for farther computations
        let orient: UIImageOrientation = self.imageOrientation
        switch orient {
        case .Left, .Right, .LeftMirrored, .RightMirrored:
            boundingSize = CGSizeMake(boundingSize.height, boundingSize.width)
        default:
            break
        }
        // Compute the target CGRect in order to keep aspect-ratio
        var dstSize: CGSize
        if !scale && (srcSize.width < boundingSize.width) && (srcSize.height < boundingSize.height) {
            //NSLog(@"Image is smaller, and we asked not to scale it in this case (scaleIfSmaller:NO)");
            dstSize = srcSize
            // no resize (we could directly return 'self' here, but we draw the image anyway to take image orientation into account)
        }
        else {
            let wRatio: CGFloat = boundingSize.width / srcSize.width
            let hRatio: CGFloat = boundingSize.height / srcSize.height
            if wRatio < hRatio {
                //NSLog(@"Width imposed, Height scaled ; ratio = %f",wRatio);
                dstSize = CGSizeMake(boundingSize.width, CGFloat(floorf(Float(srcSize.height * wRatio))))
            }
            else {
                //NSLog(@"Height imposed, Width scaled ; ratio = %f",hRatio);
                dstSize = CGSizeMake(CGFloat(floorf(Float(srcSize.width * hRatio))), boundingSize.height)
            }
        }
        return self.nk_resizedImageToSize(dstSize)!
    }
    
    public func nk_scaledWithRatio(ratio: CGFloat) -> UIImage {
        let newSize: CGSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}