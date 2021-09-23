//
//  UIView+Frame.swift
//
//  Created by Nghia Nguyen on 10/28/15.
//

import UIKit


public extension UIView {
    @objc public var nk_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    @objc public var nk_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.size.width,height: self.frame.size.height)
        }
    }
    
    @objc public var nk_width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.size.height)
        }
    }
    
    @objc public var nk_height: CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: newValue)
        }
    }
    
    @objc public var nk_cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.clipsToBounds = true
            self.layer.cornerRadius = newValue
        }
    }
    
    @objc public var nk_shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @objc public var nk_shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    @objc public var nk_shadowColor: UIColor? {
        get {
            if let color = self.layer.shadowColor {
                return UIColor(cgColor: color)
            }
            
            return nil
        }
        
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    @objc public var nk_shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    @objc public var nk_borderColor: UIColor? {
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @objc public var nk_borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    //MARK: Align with view
    @objc public func nk_alignTopView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_y = view.nk_y + view.nk_height + offset
        return self
    }
    
    @objc public func nk_alignLeadingView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_x = view.nk_x + view.nk_width + offset
        return self
    }
    
    @objc public func nk_alignTrailingView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_x = view.nk_x - self.nk_width + offset
        return self
    }
    
    @objc public func nk_alignBottomView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_y = view.nk_y - self.nk_height + offset
        return self
    }
    
    @objc public func nk_centerVerticalView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.center = CGPoint(x: self.center.x, y:
            view.center.y + offset)
        return self
    }
    
    @objc public func nk_centerHorizontalView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.center = CGPoint(x : view.center.x + offset, y: self.center.y)
        return self
    }
    
    // MARK: Pin with view
    @objc public func nk_pinTopView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_y = view.nk_y + offset
        
        return self
    }
    
    @objc public func nk_pinBottomView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_y = view.nk_y + view.nk_height - self.nk_height + offset
        
        return self
    }
    
    @objc public func nk_pinLeadingView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_x = view.nk_x + offset
        
        return self
    }
    
    @objc  public func nk_pinTrailingView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.nk_x = view.nk_x + view.nk_width - self.nk_width + offset
        
        return self
    }

    //MARK: Layout with parent
    @objc public func nk_pinTopParent(_ offset: CGFloat = 0) -> UIView {
        self.nk_y = offset
        return self
    }
    
    @objc public func nk_pinLeadingParent(_ offset: CGFloat = 0) -> UIView {
        self.nk_x = offset
        return self
    }
    
    
    @objc public func nk_pinTrailingParent(_ offset: CGFloat = 0) -> UIView {
        guard let superview = self.superview else {
            return self
        }
        
        self.nk_x = superview.nk_width - self.nk_width + offset
        return self
    }
    
    @objc public func nk_pinBottomParent(_ offset: CGFloat = 0) -> UIView {
        guard let superview = self.superview else {
            return self
        }
        
        self.nk_y = superview.nk_height - self.nk_height + offset
        return self
    }
    
    @objc public func nk_centerHorizontalParent(_ offset: CGFloat = 0) -> UIView {
        guard let superview = self.superview else {
            return self
        }
        
        self.center.x = superview.nk_width / 2
        return self
    }
    
    @objc public func nk_centerVerticalParent(_ offset: CGFloat = 0) -> UIView {
        guard let superview = self.superview else {
            return self
        }
        
        self.center.y = superview.nk_height / 2
        return self
    }
}


public extension UIView {
    @objc public func nk_convertFrameToView(_ view: UIView) -> CGRect {
        return self.convert(self.bounds, to: view)
    }
    
    @objc public func nk_convertPointToView(_ view: UIView) -> CGPoint {
        return self.convert(self.bounds.origin, to: view)
    }
    
    @objc public func nk_frameAtCenterWithSize(_ size: CGSize, offset: CGSize = CGSize.zero) -> CGRect {
        let center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        var result = CGRect.zero
        result.size = size
        result.origin = CGPoint(x: center.x - size.width / 2 + offset.width, y: center.y - size.height / 2 + offset.height)
        
        return result
    }
}
