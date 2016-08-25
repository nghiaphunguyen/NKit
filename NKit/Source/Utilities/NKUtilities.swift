//
//  NKUtilities.swift
//
//  Created by Nghia Nguyen on 12/3/15.
//

import UIKit

public func nk_delay(delay:Double,
    _ queue: dispatch_queue_t = dispatch_get_main_queue(),
    _ closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            queue, closure)
}

public func nk_async(queue: dispatch_queue_t = dispatch_get_main_queue(), _ closure:() -> ()) {
    dispatch_async(queue, closure)
}

public func nk_sync(queue: dispatch_queue_t = dispatch_get_main_queue(), _ closure:() -> ()) {
    dispatch_sync(queue, closure)
}