//
//  UIScrollView+Rx.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/21/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift

public extension UIScrollView {
    public var nk_scrollViewWillBeginDraggingObservable: Observable<CGPoint> {
        return self.rx.delegate
            .methodInvoked(#selector(UIScrollViewDelegate.scrollViewWillBeginDragging(_:)))
            .map {_ in return self.contentOffset}
    }
    
    public var nk_scrollViewWillEndScrollingObservable: Observable<CGPoint> {
        return Observable.from([self.nk_scrollViewWillBeginDeceleratingObservable,
                                self.nk_scrollViewDidEndDraggingObservable.filter {$0.1 == false}.map {$0.0}]).merge()
    }
    
    public var nk_scrollViewDidEndDraggingObservable: Observable<(CGPoint, Bool)> {
        return self.rx.delegate
            .methodInvoked(#selector(UIScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:)))
            .map {(self.contentOffset, ($0[1] as? Bool) ?? false)}
    }
    
    public var nk_scrollViewWillEndDraggingObservable: Observable<(CGPoint, CGPoint)> {
        return self.rx.delegate
            .methodInvoked(#selector(UIScrollViewDelegate.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)))
            .map {(self.contentOffset, ($0[1] as? CGPoint) ?? CGPoint.zero)}
    }
    
    public var nk_scrollViewWillBeginDeceleratingObservable: Observable<CGPoint> {
        return self.rx.delegate
            .methodInvoked(#selector(UIScrollViewDelegate.scrollViewWillBeginDecelerating(_:)))
            .map {_ in return self.contentOffset}
    }
    
    public var nk_scrollViewDidEndDeceleratingObservable: Observable<CGPoint> {
        return self.rx.delegate
            .methodInvoked(#selector(UIScrollViewDelegate.scrollViewDidEndDecelerating(_:)))
            .map {_ in return self.contentOffset}
    }
}
