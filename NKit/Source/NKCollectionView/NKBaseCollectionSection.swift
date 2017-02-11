//
//  NKBaseCollectionSection.swift
//  IgListKitExample
//
//  Created by Nghia Nguyen on 1/26/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public enum NKBaseCollectionSectionOption {
    case inset(UIEdgeInsets)
    case lineSpacing(CGFloat)
    case interitemSpacing(CGFloat)
    case header(NKListSupplementaryViewConfigurable.Type)
    case footer(NKListSupplementaryViewConfigurable.Type)
}

open class NKBaseCollectionSection: NKCollectionSection {
    public private(set) var inset: UIEdgeInsets = .zero
    public private(set) var minimumLineSpacing: CGFloat = 0
    public private(set) var minimumInteritemSpacing: CGFloat = 0
    
    public init(options: [NKBaseCollectionSectionOption]) {
        super.init()
        
        options.forEach {
            switch $0 {
            case .inset(let inset):
                self.inset = inset
            case .lineSpacing(let lineSpacing):
                self.minimumLineSpacing = lineSpacing
            case .interitemSpacing(let interitemSpacing):
                self.minimumInteritemSpacing = interitemSpacing
            case .header(let headerType):
                self.update(header: headerType)
            case .footer(let footerType):
                self.update(footer: footerType)
            }
        }
    }
    
    open override func inset(with collectionView: UICollectionView) -> UIEdgeInsets {
        return self.inset
    }
    
    open override func minimumLineSpacing(with collectionView: UICollectionView) -> CGFloat {
        return self.minimumLineSpacing
    }
    
    open override func minimumInteritemSpacing(with collectionView: UICollectionView) -> CGFloat {
        return self.minimumInteritemSpacing
    }
}
