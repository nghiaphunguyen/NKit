//
//  NKNKLogEventManager.swift
//  NKit
//
//  Created by Nghia Nguyen on 11/1/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

public protocol NKLogEventManagerProtocol {
    func logEvent(name: String, extraInfo: [String : NSObject]?)
}

public final class NKLogEventManager: AnyObject {
    public static let sharedInstance = NKLogEventManager()
    
    fileprivate var eventManagers = [NKLogEventManagerProtocol]()
    
    public func registerEventManager(_ eventManager: NKLogEventManagerProtocol) {
        self.eventManagers.append(eventManager)
    }
    
    public func log(name: String,_ extraInfo: [String : NSObject]? = nil) {
        for eventManager in self.eventManagers {
            eventManager.logEvent(name: name, extraInfo: extraInfo)
        }
    }
}

public let NKEVENT = NKLogEventManager.sharedInstance
