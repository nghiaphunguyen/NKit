//
//  NKSize.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/10/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit


public protocol NKSize {
    var width: CGFloat {get}
    var height: CGFloat {get}
    var size: CGSize {get}
}

extension CGFloat: NKSize {
    public var width: CGFloat {
        return 0
    }
    
    public var height: CGFloat {
        return self
    }
    
    public var size: CGSize {
        return CGSize(width: self.width, height: self.height)
    }
}

extension CGSize: NKSize {
    public var size: CGSize {
        return self
    }
}
