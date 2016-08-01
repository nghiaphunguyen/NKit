//
//  UIView+Frame.swift
//
//  Created by Nghia Nguyen on 10/28/15.
//

import UIKit

public extension UIView {
    public var nk_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame = CGRectMake(newValue, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
        }
    }
    
    public var nk_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set {
            self.frame = CGRectMake(self.frame.origin.x, newValue, self.frame.size.width, self.frame.size.height)
        }
    }
    
    public var nk_width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newValue, self.frame.size.height)
        }
    }
    
    public var nk_height: CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newValue)
        }
    }
    
    public var nk_cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.clipsToBounds = true
            self.layer.cornerRadius = newValue
        }
    }
    
    public var nk_shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    public var nk_shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    public var nk_shadowColor: UIColor? {
        get {
            if let color = self.layer.shadowColor {
                return UIColor(CGColor: color)
            }
            
            return nil
        }
        
        set {
            self.layer.shadowColor = newValue?.CGColor
        }
    }
    
    public var nk_shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    public var nk_borderColor: UIColor? {
        get {
            if let color = self.layer.borderColor {
                return UIColor(CGColor: color)
            }
            return nil
        }
        
        set {
            self.layer.borderColor = newValue?.CGColor
        }
    }
    
    public var nk_borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    //MARK: Align with view
    public func nk_alignTopView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_y = view.nk_y + view.nk_height + offset
        return self
    }
    
    public func nk_alignLeadingView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_x = view.nk_x + view.nk_width + offset
        return self
    }
    
    public func nk_alignTrailingView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_x = view.nk_x - self.nk_width + offset
        return self
    }
    
    public func nk_alignBottomView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_y = view.nk_y - self.nk_height + offset
        return self
    }
    
    public func nk_centerVerticalView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.center = CGPointMake(self.center.x, view.center.y + offset)
        return self
    }
    
    public func nk_centerHorizontalView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.center = CGPointMake(view.center.x + offset, self.center.y)
        return self
    }
    
    // MARK: Pin with view
    public func nk_pinTopView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_y = view.nk_y + offset
        
        return self
    }
    
    public func nk_pinBottomView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_y = view.nk_y + view.nk_height - self.nk_height + offset
        
        return self
    }
    
    public func nk_pinLeadingView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_x = view.nk_x + offset
        
        return self
    }
    
    public func nk_pinTrailingView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_x = view.nk_x + view.nk_width - self.nk_width + offset
        
        return self
    }

    //MARK: Layout with parent
    public func nk_pinTopParent(offset: CGFloat = 0) -> UIView {
        self.nk_y = offset
        return self
    }
    
    public func nk_pinLeadingParent(offset: CGFloat = 0) -> UIView {
        self.nk_x = offset
        return self
    }
    
    
    public func nk_pinTrailingParent(offset: CGFloat = 0) -> UIView {
        guard let superview = self.superview else {
            return self
        }
        
        self.nk_x = superview.nk_width - self.nk_width + offset
        return self
    }
    
    public func nk_pinBottomParent(offset: CGFloat = 0) -> UIView {
        guard let superview = self.superview else {
            return self
        }
        
        self.nk_y = superview.nk_height - self.nk_height + offset
        return self
    }
    
    public func nk_centerHorizontalParent(offset: CGFloat = 0) -> UIView {
        guard let superview = self.superview else {
            return self
        }
        
        self.center.x = superview.nk_width / 2
        return self
    }
    
    public func nk_centerVerticalParent(offset: CGFloat = 0) -> UIView {
        guard let superview = self.superview else {
            return self
        }
        
        self.center.y = superview.nk_height / 2
        return self
    }
}


public extension UIView {
    public func nk_convertFrameToView(view: UIView) -> CGRect {
        return self.convertRect(self.bounds, toView: view)
    }
    
    public func nk_convertPointToView(view: UIView) -> CGPoint {
        return self.convertPoint(self.bounds.origin, toView: view)
    }
}