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

    var drawRectCompletion: ((_ view: NKDrawView, _ extraInfo: [String]) -> Void)?
    var extraInfo = [String ]()
    
    convenience init(drawRect: @escaping (_ view: NKDrawView, _ extraInfo: [String]) -> Void) {
        self.init(frame: CGRect.zero)
        
        self.drawRectCompletion = drawRect
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.drawRectCompletion?(self, extraInfo)
    }
}
