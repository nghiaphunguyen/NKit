//
//  StackView+Layout.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/26/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import TZStackView

public extension TZStackView {
    public func nk_addArrangedSubview<T: UIView>(_ view: T, config: ((T) -> Void)? = nil) -> Self {
        self.addArrangedSubview(view)
        config?(view)
        return self
    }
    
    public static func nk_create(_ distribution: TZStackViewDistribution = .fill, alignment: TZStackViewAlignment = .fill, spacing: CGFloat = 0, axis: UILayoutConstraintAxis = .vertical) -> TZStackView {
        let stackView = TZStackView()
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.axis = axis
        return stackView
    }
    
    public static func nk_row(_ distribution: TZStackViewDistribution = .fill, alignment: TZStackViewAlignment = .fill, spacing: CGFloat = 0) -> TZStackView {
        return self.nk_create(distribution, alignment: alignment, spacing: spacing, axis: .horizontal)
    }
    
    public static func nk_column(_ distribution: TZStackViewDistribution = .fill, alignment: TZStackViewAlignment = .fill, spacing: CGFloat = 0) -> TZStackView {
        return self.nk_create(distribution, alignment: alignment, spacing: spacing, axis: .vertical)
    }
}
