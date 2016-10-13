//
//  NKLayerView.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 3/16/16.
//  Copyright © 2016 misfit. All rights reserved.
//

import Foundation
import UIKit
class NKDrawView: UIView {

    var drawRectCompletion: ((_ view: NKDrawView, _ extraInfo: [String: AnyObject]) -> Void)?
    var extraInfo = [String : AnyObject]()
    
    convenience init(drawRect: @escaping (_ view: NKDrawView, _ extraInfo: [String: AnyObject]) -> Void) {
        self.init(frame: CGRect.zero)
        
        self.drawRectCompletion = drawRect
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.drawRectCompletion?(self, extraInfo)
    }
}
