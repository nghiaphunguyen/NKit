//
//  NKNKLogEventManager.swift
//  NKit
//
//  Created by Nghia Nguyen on 11/1/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

public enum NKEventType {
    case screen
    case normal
}

public protocol NKLogEventManagerProtocol {
    func logEvent(name: String, type: NKEventType, extraInfo: [String : NSObject]?)
}

public final class NKLogEventManager {
    public static let sharedInstance = NKLogEventManager()
    
    fileprivate var eventManagers = [NKLogEventManagerProtocol]()
    
    public func registerEventManager(_ eventManager: NKLogEventManagerProtocol) {
        self.eventManagers.append(eventManager)
    }
    
    public func log(name: String, type: NKEventType = .normal, extraInfo: [String : NSObject]? = nil) {
        for eventManager in self.eventManagers {
            eventManager.logEvent(name: name, type: type, extraInfo: extraInfo)
        }
    }
}

public let NKEVENT = NKLogEventManager.sharedInstance
