//
//  NKNKLogEventManager.swift
//  NKit
//
//  Created by Nghia Nguyen on 11/1/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

protocol NKLogEventManagerProtocol {
    func logEvent(_ name: String, extraInfo: [String : NSObject]?)
}

class NKLogEventManager: AnyObject {
    static let sharedInstance = NKLogEventManager()
    
    fileprivate var eventManagers = [NKLogEventManagerProtocol]()
    
    func registerEventManager(_ eventManager: NKLogEventManagerProtocol) {
        self.eventManagers.append(eventManager)
    }
    
    func log(_ name: String,_ extraInfo: [String : NSObject]? = nil) {
        for eventManager in self.eventManagers {
            eventManager.logEvent(name, extraInfo: extraInfo)
        }
    }
}

let NKEVENT = NKLogEventManager.sharedInstance
