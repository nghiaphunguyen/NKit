//
//  UIView+Autolayout.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/3/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit
import SnapKit

//MARK: Border

public enum NKEdgePos{
    case Top
    case Bottom
    case Leading
    case Trailing
}

public extension UIView {
    public func nk_addBorder(pos pos: NKEdgePos, lineWidth: Double,
        offset1: Double = 0, offset2: Double = 0, color: UIColor) -> UIView {
        let border = UIView()
        border.backgroundColor = color
        
        self.addSubview(border)
        
        border.snp_makeConstraints { (make) -> Void in
            switch pos {
            case .Top:
                make.top.equalTo(self)
            case .Bottom:
                make.bottom.equalTo(self)
                
            case .Leading:
                make.leading.equalTo(self)
            case .Trailing:
                make.trailing.equalTo(self)
            }
            
            switch pos {
            case .Top, .Bottom:
                make.height.equalTo(lineWidth)
                make.leading.equalTo(self).offset(offset1)
                make.trailing.equalTo(self).offset(-offset2)
            case .Leading, .Trailing:
                make.width.equalTo(lineWidth)
                make.top.equalTo(self).offset(offset1)
                make.bottom.equalTo(self).offset(-offset2)
            }
        }
        
        return border
    }
}

//MARK: Divide views
public enum NKOrientationType {
    case Horizontal
    case Vertical
}

public extension UIView {
    public func nk_divideViews(num num: UInt, type: NKOrientationType) -> [UIView] {
        var views = [UIView]()
        
        for i in 0..<num {
            let view = UIView()
            views.append(view)
            
            self.addSubview(view)
            
            view.snp_makeConstraints(closure: { (make) -> Void in
                make.bottom.equalTo(self)
                
                switch type {
                case .Horizontal:
                    make.width.equalTo(self)
                    make.height.equalTo(self).dividedBy(num)
                    if (i == 0) {
                        make.leading.equalTo(self)
                    } else {
                        make.leading.equalTo(views[Int(i)-1].snp_trailing)
                    }
                    
                case .Vertical:
                    make.width.equalTo(self).dividedBy(num)
                    make.height.equalTo(self)
                    if (i == 0) {
                        make.top.equalTo(self)
                    } else {
                        make.top.equalTo(views[Int(i)-1].snp_bottom)
                    }
                }
            })
        }
        
        return views
    }
}

public extension UIView {
    public static func nk_spaceOutAllViews(
        views: [UIView],
        offset: CGFloat,
        type: NKOrientationType) {
        if views.count < 2 {
            return
        }
        
        var source = views.first!
        for i in 1..<views.count {
            let view = views[i]
            view.snp_makeConstraints(closure: { (make) -> Void in
                
                switch type {
                case .Horizontal:
                    make.leading.equalTo(source.snp_trailing).offset(offset)
                case .Vertical:
                    make.top.equalTo(source.snp_bottom).offset(offset)
                }
            })
            
            source = view
        }
    }
    
    public static func nk_alignAllViews(views: [UIView], edgePos: NKEdgePos) {
        if views.count < 2 {
            return
        }
        
        let source = views.first!
        for i in 1..<views.count {
            let view = views[i]
            view.snp_makeConstraints(closure: { (make) -> Void in
                switch edgePos {
                case .Bottom:
                    make.bottom.equalTo(source)
                case .Leading:
                    make.leading.equalTo(source)
                case .Trailing:
                    make.trailing.equalTo(source)
                case .Top:
                    make.top.equalTo(source)
                }
            })
        }
    }
    
    public static func nk_equalsHeightForViews(views: [UIView]) {
        if views.count < 2 {
            return
        }
        
        let source = views.first!
        for i in 1..<views.count {
            let view = views[i]
            view.snp_makeConstraints(closure: { (make) -> Void in
                make.height.equalTo(source)
            })
        }
    }
    
    public static func nk_equalsWidthForViews(views: [UIView]) {
        if views.count < 2 {
            return
        }
        
        let source = views.first!
        for i in 1..<views.count {
            let view = views[i]
            view.snp_makeConstraints(closure: { (make) -> Void in
                make.width.equalTo(source)
            })
        }
    }
}