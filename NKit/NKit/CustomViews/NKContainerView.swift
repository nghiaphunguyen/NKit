//
//  NKShadowView.swift
//
//  Created by Nghia Nguyen on 2/20/16.
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
                view.layoutIfNeeded()
            }
        }
    }
    
    public var nk_shadowColor = UIColor.grayColor() {
        didSet {
            self.nk_shadowView.hidden = false
            self.nk_shadowView.backgroundColor = self.nk_shadowColor
        }
    }
    public var nk_shadowRadius: CGFloat = 0 {
        didSet {
            self.nk_shadowView.hidden = false
            self.nk_shadowView.clipsToBounds = true
            self.nk_shadowView.layer.cornerRadius = self.nk_shadowRadius
        }
    }
    public var nk_shadowOffset: CGSize = CGSizeMake(0, 0) {
        didSet {
            self.nk_shadowView.hidden = false
            self.nk_shadowView.snp_remakeConstraints { (make) -> Void in
                if self.nk_shadowOffset.width < 0 {
                    make.leading.equalTo(0).offset(self.nk_shadowOffset.width)
                    make.trailing.equalTo(0)
                } else {
                    make.trailing.equalTo(0).offset(self.nk_shadowOffset.width)
                    make.leading.equalTo(0)
                }
                
                if self.nk_shadowOffset.height < 0 {
                    make.top.equalTo(0).offset(self.nk_shadowOffset.height)
                    make.bottom.equalTo(0)
                } else {
                    make.top.equalTo(0)
                    make.bottom.equalTo(0).offset(self.nk_shadowOffset.height)
                }
            }
        }
    }

    public var nk_shadowView: UIView = {
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
            
            self.insertSubview(self.nk_shadowView, atIndex: 0)
            
            let color = self.nk_shadowColor
            self.nk_shadowColor = color
            
            let offset = self.nk_shadowOffset
            self.nk_shadowOffset = offset
            
            let radius = self.nk_shadowRadius
            self.nk_shadowRadius = radius
        }
    }
    
    convenience public init(contentView: T? = nil) {
        self.init(frame: CGRect.zero)
        
        self.contentView = contentView
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
        self.addSubview(self.nk_shadowView)
        self.nk_shadowView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
    }
}
