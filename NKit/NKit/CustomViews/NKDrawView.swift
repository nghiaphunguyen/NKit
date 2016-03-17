//
//  NKLayerView.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 3/16/16.
//  Copyright © 2016 misfit. All rights reserved.
//

import Foundation

class NKDrawView: UIView {

    var drawRectCompletion: ((view: NKDrawView, extraInfo: [String: AnyObject]) -> Void)?
    var extraInfo = [String : AnyObject]()
    
    convenience init(drawRect: (view: NKDrawView, extraInfo: [String: AnyObject]) -> Void) {
        self.init(frame: CGRect.zero)
        
        self.drawRectCompletion = drawRect
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.drawRectCompletion?(view: self, extraInfo: extraInfo)
    }
}