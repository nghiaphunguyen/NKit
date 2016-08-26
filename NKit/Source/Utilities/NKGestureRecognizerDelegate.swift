//
//  NKGestureRecognizerDelegate.swift
//  NKit
//
//  Created by Nghia Nguyen on 8/26/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

final class NKGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}