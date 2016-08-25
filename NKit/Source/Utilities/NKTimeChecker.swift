//
//  TimeChecker.swift
//  FastSell
//
//  Created by Nghia Nguyen on 8/24/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import Foundation
import RxSwift
import NRxSwift

public final class NKTimeChecker: AnyObject {
    private(set) var latestSuccessfulCheckingTime: NSTimeInterval = 0
    let timeInterval: NSTimeInterval
    
    public init(timeInterval: NSTimeInterval) {
        self.timeInterval  = timeInterval
    }
    
    public func checkTime() -> Observable<Bool> {
        return Observable.just(NSDate().timeIntervalSince1970 - self.latestSuccessfulCheckingTime >= self.timeInterval)
    }
    
    public func updateLatestSuccessfullCheckingTime(time: NSTimeInterval = NSDate().timeIntervalSince1970) -> Void {
        self.latestSuccessfulCheckingTime = time
    }
}