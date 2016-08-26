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
    private(set) var latestSuccessfulCheckingTime: NSTimeInterval = 0 {
        didSet {
            guard let key = self.key else {
                return
            }
            
            NSUserDefaults.standardUserDefaults().setDouble(latestSuccessfulCheckingTime, forKey: key)
        }
    }
    
    let timeInterval: NSTimeInterval
    let key: String?
    public init(timeInterval: NSTimeInterval, key: String? = nil) {
        self.timeInterval  = timeInterval
        self.key = key
        
        if let key = self.key {
            self.latestSuccessfulCheckingTime = NSUserDefaults.standardUserDefaults().doubleForKey(key)
        }
    }
    
    public func checkTime() -> Observable<Bool> {
        return Observable.just(NSDate().timeIntervalSince1970 - self.latestSuccessfulCheckingTime >= self.timeInterval)
    }
    
    public func updateLatestSuccessfullCheckingTime(time: NSTimeInterval = NSDate().timeIntervalSince1970) -> Void {
        self.latestSuccessfulCheckingTime = time
    }
}