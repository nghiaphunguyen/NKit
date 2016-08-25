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

final class TimeChecker: AnyObject {
    private(set) var latestSuccessfulCheckingTime: NSTimeInterval = 0
    let timeInterval: NSTimeInterval
    
    init(timeInterval: NSTimeInterval) {
        self.timeInterval  = timeInterval
    }
    
    func checkTime() -> Observable<Bool> {
        return Observable.just(NSDate().timeIntervalSince1970 - self.latestSuccessfulCheckingTime >= self.timeInterval)
    }
    
    func updateLatestSuccessfullCheckingTime(time: NSTimeInterval = NSDate().timeIntervalSince1970) -> Void {
        self.latestSuccessfulCheckingTime = time
    }
}