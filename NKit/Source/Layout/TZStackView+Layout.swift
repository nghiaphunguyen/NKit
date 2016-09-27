//
//  StackView+Layout.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/26/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import NTZStackView

public extension TZStackView {
    public func nk_addArrangedSubview<T: UIView>(view: T, _ config: ((T) -> Void)? = nil) -> Self {
        self.addArrangedSubview(view)
        config?(view)
        return self
    }
    
    public static func nk_create(distribution: TZStackViewDistribution = .Fill, alignment: TZStackViewAlignment = .Fill, spacing: CGFloat = 0, axis: UILayoutConstraintAxis = .Vertical) -> TZStackView {
        let stackView = TZStackView()
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.axis = axis
        return stackView
    }
    
    public static func nk_row(distribution: TZStackViewDistribution = .Fill, _ alignment: TZStackViewAlignment = .Fill, _ spacing: CGFloat = 0) -> TZStackView {
        return self.nk_create(distribution, alignment: alignment, spacing: spacing, axis: .Horizontal)
    }
    
    public static func nk_column(distribution: TZStackViewDistribution = .Fill, _ alignment: TZStackViewAlignment = .Fill, _ spacing: CGFloat = 0) -> TZStackView {
        return self.nk_create(distribution, alignment: alignment, spacing: spacing, axis: .Vertical)
    }
}
