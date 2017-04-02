//
//  NKProxy.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public struct NKProxy: NKProxyable {
    
    var handlers = [NKHandlable.Type]()
    
    public mutating func add(handler: NKHandlable.Type) {
        self.handlers.append(handler)
    }
    
    public mutating func remove(handler: NKHandlable.Type) {
        if let index = self.handlers.index(where: { $0 == handler }) {
            self.handlers.remove(at: index)
        }
    }
    
    public func getHandler(withPayload payload: Any) -> NKHandlable? {
        for handler in self.handlers {
            if let handler = handler.init(payload: payload) {
                return handler
            }
        }
        
        return nil
    }
    
}
