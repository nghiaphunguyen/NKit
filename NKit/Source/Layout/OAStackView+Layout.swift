//
//  OAStackView.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import OAStackView

public extension OAStackView {
    public func nk_addArrangedSubview<T: UIView>(view: T, _ config: ((T) -> Void)? = nil) -> Self {
        self.addArrangedSubview(view)
        config?(view)
        return self
    }
    
    public static func nk_create(distribution: OAStackViewDistribution = .Fill, alignment: OAStackViewAlignment = .Fill, spacing: CGFloat = 0, axis: UILayoutConstraintAxis = .Vertical) -> OAStackView {
        let stackView = OAStackView()
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.axis = axis
        return stackView
    }
    
    public static func nk_row(distribution: OAStackViewDistribution = .Fill, _ alignment: OAStackViewAlignment = .Fill, _ spacing: CGFloat = 0) -> OAStackView {
        return self.nk_create(distribution, alignment: alignment, spacing: spacing, axis: .Horizontal)
    }
    
    public static func nk_column(distribution: OAStackViewDistribution = .Fill, _ alignment: OAStackViewAlignment = .Fill, _ spacing: CGFloat = 0) -> OAStackView {
        return self.nk_create(distribution, alignment: alignment, spacing: spacing, axis: .Vertical)
    }
}

