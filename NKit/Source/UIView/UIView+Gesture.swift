//
//  UIView+Gesture.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/12/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public extension UIView {
    public func rx_pan(numOfTouches: Int = 1) -> Observable<UIPanGestureRecognizer> {
        let panGesture = UIPanGestureRecognizer()
        panGesture.minimumNumberOfTouches = numOfTouches
        self.addGestureRecognizer(panGesture)
        
        return panGesture.rx_event.asObservable()
    }
    
    public func rx_pinch() -> Observable<UIPinchGestureRecognizer> {
        let pinchGesture = UIPinchGestureRecognizer()
        self.addGestureRecognizer(pinchGesture)
        
        return pinchGesture.rx_event.asObservable()
    }
    
    public func rx_tap(numOfTaps: Int = 1) -> Observable<UITapGestureRecognizer> {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = numOfTaps
        self.addGestureRecognizer(tapGesture)
        
        return tapGesture.rx_event.asObservable()
    }
    
    public func rx_longPress(numOfTouchs: Int = 1) -> Observable<UILongPressGestureRecognizer> {
        let gesture = UILongPressGestureRecognizer()
        gesture.numberOfTouchesRequired = numOfTouchs
        self.addGestureRecognizer(gesture)
        
        return gesture.rx_event.asObservable()
    }
    
    public func rx_swipe(numOfTouchs: Int = 1) -> Observable<UISwipeGestureRecognizer> {
        let gesture = UISwipeGestureRecognizer()
        gesture.numberOfTouchesRequired = numOfTouchs
        self.addGestureRecognizer(gesture)
        
        return gesture.rx_event.asObservable()
    }
    
    public func rx_rotate() -> Observable<UIRotationGestureRecognizer> {
        let gesture = UIRotationGestureRecognizer()
        self.addGestureRecognizer(gesture)
        return gesture.rx_event.asObservable()
    }
    
    public func rx_edgePan(numOfTouch: Int = 1) -> Observable<UIScreenEdgePanGestureRecognizer> {
        let gesture = UIScreenEdgePanGestureRecognizer()
        gesture.minimumNumberOfTouches = numOfTouch
        self.addGestureRecognizer(gesture)
        
        return gesture.rx_event.asObservable()
    }
}
