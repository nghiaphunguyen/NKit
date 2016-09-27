//
//  UIStackView.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
public extension UIStackView {
    public func nk_addArrangedSubview<T: UIView>(view: T, _ config: ((T) -> Void)? = nil) -> Self {
        self.addArrangedSubview(view)
        config?(view)
        return self
    }
    
    public static func nk_create(distribution: UIStackViewDistribution = .Fill, alignment: UIStackViewAlignment = .Fill, spacing: CGFloat = 0, axis: UILayoutConstraintAxis = .Vertical) -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.axis = axis
        return stackView
    }
    
    public static func nk_row(distribution: UIStackViewDistribution = .Fill, _ alignment: UIStackViewAlignment = .Fill, _ spacing: CGFloat = 0) -> UIStackView {
        return self.nk_create(distribution, alignment: alignment, spacing: spacing, axis: .Horizontal)
    }
    
    public static func nk_column(distribution: UIStackViewDistribution = .Fill, _ alignment: UIStackViewAlignment = .Fill, _ spacing: CGFloat = 0) -> UIStackView {
        return self.nk_create(distribution, alignment: alignment, spacing: spacing, axis: .Vertical)
    }
}

