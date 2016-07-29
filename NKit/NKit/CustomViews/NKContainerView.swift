//
//  NKShadowView.swift
//  FastSell
//
//  Created by Nghia Nguyen on 2/20/16.
//  Copyright © 2016 vn.fastsell. All rights reserved.
//

import UIKit
import SnapKit

public class NKContainerView<T: UIView>: NKBaseView{
    
    public var contentView: T? {
        didSet {
            
            if let oldView = oldValue {
                oldView.snp_removeConstraints()
                
                if let _ = oldView.superview {
                    oldView.removeFromSuperview()
                }
            }
            
            if let view = self.contentView {
                self.addSubview(view)
                self.bringSubviewToFront(view)
            }
        }
    }
    
    public var nk_c_shadowColor = UIColor.grayColor() {
        didSet {
            self.nk_c_shadowView.hidden = false
            self.nk_c_shadowView.backgroundColor = self.nk_c_shadowColor
        }
    }
    public var nk_c_shadowRadius: CGFloat = 0 {
        didSet {
            self.nk_c_shadowView.hidden = false
            self.nk_c_shadowView.clipsToBounds = true
            self.nk_c_shadowView.layer.cornerRadius = self.nk_c_shadowRadius
        }
    }
    public var nk_c_shadowOffset: CGSize = CGSizeMake(0, 0) {
        didSet {
            self.nk_c_shadowView.hidden = false
            self.nk_c_shadowView.snp_remakeConstraints { (make) -> Void in
                if self.nk_c_shadowOffset.width < 0 {
                    make.leading.equalTo(0).offset(self.nk_c_shadowOffset.width)
                    make.trailing.equalTo(0)
                } else {
                    make.trailing.equalTo(0).offset(self.nk_c_shadowOffset.width)
                    make.leading.equalTo(0)
                }
                
                if self.nk_c_shadowOffset.height < 0 {
                    make.top.equalTo(0).offset(self.nk_c_shadowOffset.height)
                    make.bottom.equalTo(0)
                } else {
                    make.top.equalTo(0)
                    make.bottom.equalTo(0).offset(self.nk_c_shadowOffset.height)
                }
            }
        }
    }
    
    public var nk_c_shadowView: UIView = {
        let view = UIView()
        view.hidden = true
        view.clipsToBounds = true
        return view
        }() {
        didSet {
            if let _ = oldValue.superview {
                oldValue.snp_removeConstraints()
                oldValue.removeFromSuperview()
            }
            
            self.addSubview(self.nk_c_shadowView)
            self.sendSubviewToBack(self.nk_c_shadowView)
            
            let color = self.nk_c_shadowColor
            self.nk_c_shadowColor = color
            
            let offset = self.nk_c_shadowOffset
            self.nk_c_shadowOffset = offset
            
            let radius = self.nk_c_shadowRadius
            self.nk_c_shadowRadius = radius
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.internalSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.internalSetup()
    }
    
    private func internalSetup() {
        self.addSubview(self.nk_c_shadowView)
        self.sendSubviewToBack(self.nk_c_shadowView)
        self.nk_c_shadowView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
    }
    
    public func addContentView(contentView: T, withEdges edgeInsets: UIEdgeInsets = UIEdgeInsetsZero) -> Self {
        self.contentView = contentView
        
        self.contentView?.snp_remakeConstraints(closure: { (make) -> Void in
            make.edges.equalTo(edgeInsets)
        })
        
        return self
    }
    
    public static func createContainerViewWithViews(views: [UIView]) -> NKContainerView<UIView> {
        let containerView = UIView()
        for view in views {
            containerView.addSubview(view)
        }
        
        return NKContainerView<UIView>().addContentView(containerView)
    }
}
