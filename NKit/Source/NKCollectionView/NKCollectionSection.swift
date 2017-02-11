//
//  NKCollectionSection.swift
//  IgListKitExample
//
//  Created by Nghia Nguyen on 1/24/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import Foundation
import UIKit

open class NKCollectionSection: NKListSection {
    open func inset(with collectionView: UICollectionView) -> UIEdgeInsets {
        return .zero
    }
    
    open func minimumLineSpacing(with collectionView: UICollectionView) -> CGFloat {
        return 0
    }
    
    open func minimumInteritemSpacing(with collectionView: UICollectionView) -> CGFloat {
        return 0
    }
}
