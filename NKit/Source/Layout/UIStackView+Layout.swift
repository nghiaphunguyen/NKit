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
    @discardableResult public func nk_addArrangedSubview<T: UIView>(_ view: T, config: ((T) -> Void)? = nil) -> Self {
        self.addArrangedSubview(view)
        config?(view)
        return self
    }
    
    @discardableResult public static func nk_create(_ distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0, axis: NSLayoutConstraint.Axis = .vertical) -> Self {
        let stackView = self.init()
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.axis = axis
        return stackView
    }
    
    @discardableResult public static func nk_row(_ distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0) -> Self {
        return self.nk_create(distribution, alignment: alignment, spacing: spacing, axis: .horizontal)
    }
    
    @discardableResult public static func nk_column(_ distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0) -> Self {
        return self.nk_create(distribution, alignment: alignment, spacing: spacing, axis: .vertical)
    }
}

