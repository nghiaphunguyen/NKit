//
//  NKNotificationProxy.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public struct NKNotificationProxy: NKNotificationProxyable {
    
    public static let instance: NKNotificationProxyable = {
        var instance = NKNotificationProxy()
        return instance
    }()
    
    var handlers = [NKNotificationHandlable.Type]()
    
    public mutating func add(handler: NKNotificationHandlable.Type) {
        self.handlers.append(handler)
    }
    
    public mutating func remove(handler: NKNotificationHandlable.Type) {
        if let index = self.handlers.index(where: { $0 == handler }) {
            self.handlers.remove(at: index)
        }
    }
    
    public func getNotificationHandler(withJSON json: [String : Any]) -> NKNotificationHandlable? {
        for handler in self.handlers {
            if let handler = handler.instance(withJSON: json) {
                return handler
            }
        }
        
        return nil
    }
}
