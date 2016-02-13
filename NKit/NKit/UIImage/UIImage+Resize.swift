//
//  UIImage+Resize.m
//
//  Created by Olivier Halligon on 12/08/09.
//  Copyright 2009 AliSoftware. All rights reserved.
//
public extension UIImage {
    public func nk_resizedImageToSize(dstSize: CGSize) -> UIImage? {
        var dstSize = dstSize
        
        let imgRef: CGImageRef = self.CGImage!
        // the below values are regardless of orientation : for UIImages from Camera, width>height (landscape)
        let srcSize: CGSize = CGSizeMake(CGFloat(CGImageGetWidth(imgRef)), CGFloat(CGImageGetHeight(imgRef)))
        // not equivalent to self.size (which is dependant on the imageOrientation)!
        /* Don't resize if we already meet the required destination size. */
        if CGSizeEqualToSize(srcSize, dstSize) {
            
        }
        let scaleRatio: CGFloat = dstSize.width / srcSize.width
        let orient: UIImageOrientation = self.imageOrientation
        var transform: CGAffineTransform = CGAffineTransformIdentity
        switch orient {
        case .Up:
            //EXIF = 1
            transform = CGAffineTransformIdentity
        case .UpMirrored:
            //EXIF = 2
            transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0)
            transform = CGAffineTransformScale(transform, -1.0, 1.0)
        case .Down:
            //EXIF = 3
            transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        case .DownMirrored:
            //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.height)
            transform = CGAffineTransformScale(transform, 1.0, -1.0)
        case .LeftMirrored:
            //EXIF = 5
            dstSize = CGSizeMake(dstSize.height, dstSize.width)
            transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width)
            transform = CGAffineTransformScale(transform, -1.0, 1.0)
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI_2))
        case .Left:
            //EXIF = 6
            dstSize = CGSizeMake(dstSize.height, dstSize.width)
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.width)
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI_2))
        case .RightMirrored:
            //EXIF = 7
            dstSize = CGSizeMake(dstSize.height, dstSize.width)
            transform = CGAffineTransformMakeScale(-1.0, 1.0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        case .Right:
            //EXIF = 8
            dstSize = CGSizeMake(dstSize.height, dstSize.width)
            transform = CGAffineTransformMakeTranslation(srcSize.height, 0.0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        }
        /////////////////////////////////////////////////////////////////////////////
        // The actual resize: draw the image on a new context, applying a transform matrix
        UIGraphicsBeginImageContextWithOptions(dstSize, false, UIScreen.mainScreen().scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        if orient == .Right || orient == .Left {
            CGContextScaleCTM(context, -scaleRatio, scaleRatio)
            CGContextTranslateCTM(context, -srcSize.height, 0)
        }
        else {
            CGContextScaleCTM(context, scaleRatio, -scaleRatio)
            CGContextTranslateCTM(context, 0, -srcSize.height)
        }
        CGContextConcatCTM(context, transform)
        // we use srcSize (and not dstSize) as the size to specify is in user space (and we use the CTM to apply a scaleRatio)
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, srcSize.width, srcSize.height), imgRef)
        let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
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