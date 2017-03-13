//
//  OAStackView+NKit.swift
//  NKit
//
//  Created by Nghia Nguyen on 3/13/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import OAStackView

public extension OAStackView {
    @discardableResult public func nk_addArrangedSubview<T: UIView>(_ view: T, config: ((T) -> Void)? = nil) -> Self {
        self.addArrangedSubview(view)
        config?(view)
        return self
    }
    
    @discardableResult public static func nk_create(_ distribution: OAStackViewDistribution = .fill, alignment: OAStackViewAlignment = .fill, spacing: CGFloat = 0, axis: UILayoutConstraintAxis = .vertical) -> Self {
        let stackView = self.init()
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.axis = axis
        return stackView
    }
    
    @discardableResult public static func nk_row(_ distribution: OAStackViewDistribution = .fill, alignment: OAStackViewAlignment = .fill, spacing: CGFloat = 0) -> Self {
        return self.nk_create(distribution, alignment: alignment, spacing: spacing, axis: .horizontal)
    }
    
    @discardableResult public static func nk_column(_ distribution: OAStackViewDistribution = .fill, alignment: OAStackViewAlignment = .fill, spacing: CGFloat = 0) -> Self {
        return self.nk_create(distribution, alignment: alignment, spacing: spacing, axis: .vertical)
    }
}
