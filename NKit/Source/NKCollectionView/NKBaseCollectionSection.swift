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
}

open class NKBaseCollectionSection: NKCollectionSection {
    private var inset: UIEdgeInsets = .zero
    private var minimumLineSpacing: CGFloat = 0
    private var minimumInteritemSpacing: CGFloat = 0
    
    init(options: [NKBaseCollectionSectionOption]) {
        super.init()
        
        options.forEach {
            switch $0 {
            case .inset(let inset):
                self.inset = inset
            case .lineSpacing(let lineSpacing):
                self.minimumLineSpacing = lineSpacing
            case .interitemSpacing(let interitemSpacing):
                self.minimumInteritemSpacing = interitemSpacing
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
