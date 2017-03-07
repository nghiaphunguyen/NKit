//
//  NSObject+NKStyle.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/7/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public extension NSObject {
    private func configStyles(_ styles: [NKStylable]) -> Self {
        styles.forEach({
            $0.style(self)
        })
        
        return self
    }
    
    @discardableResult public func nk_styles(_ styles: [NKStylable]) -> Self {
        return self.configStyles(styles)
    }
    
    @discardableResult public func nk_styles(_ styles: NKStylable...) -> Self {
        return self.configStyles(styles)
    }
}
