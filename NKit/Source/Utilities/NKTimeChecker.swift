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
    private(set) var latestSuccessfulCheckingTime: TimeInterval = 0 {
        didSet {
            guard let key = self.key else {
                return
            }
            
            UserDefaults.standard.set(latestSuccessfulCheckingTime, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    let timeInterval: TimeInterval
    let key: String?
    public init(timeInterval: TimeInterval, key: String? = nil) {
        self.timeInterval  = timeInterval
        self.key = key
        
        if let key = self.key {
            self.latestSuccessfulCheckingTime = UserDefaults.standard.double(forKey: key)
        }
    }
    
    public func checkTime() -> Bool {
        return NSDate().timeIntervalSince1970 - self.latestSuccessfulCheckingTime >= self.timeInterval
    }
    
    public func checkTimeObservable() -> Observable<Bool> {
        return Observable.nk_baseCreate({ (observer) in
            observer.nk_setValue(self.checkTime())
        })
    }
    
    
    public func updateLatestSuccessfullCheckingTime(time: TimeInterval = NSDate().timeIntervalSince1970) -> Void {
        self.latestSuccessfulCheckingTime = time
    }
}
