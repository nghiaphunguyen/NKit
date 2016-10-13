//
//  NKUtilities.swift
//
//  Created by Nghia Nguyen on 12/3/15.
//

import UIKit

public func nk_delay(_ delay:Double,
    _ queue: DispatchQueue = DispatchQueue.main,
    _ closure:@escaping ()->()) {
        queue.asyncAfter(deadline: .now() + delay, execute: {
            closure()
        })
}

public func nk_async(queue: DispatchQueue = DispatchQueue.main, _ closure: @escaping () -> ()) {
    queue.async(execute: closure)
}

public func nk_sync(queue: DispatchQueue = DispatchQueue.main, _ closure:() -> ()) {
    queue.sync(execute: closure)
}

public func CGRectMake(_ x: CGFloat, _ y :CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}

public func CGSizeMake(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    return CGSize(width: width, height: height)
}

public func CGPointMake(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y)
}

public func UIEdgeInsetsMake(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
}
