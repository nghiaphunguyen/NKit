//
//  NKCollectionSupplementaryViewConfigurable.swift
//  IgListKitExample
//
//  Created by Nghia Nguyen on 1/26/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKCollectionSupplementaryViewConfigurable: class, NKIdentifier {
    
    func collectionView(_ collectionView: UICollectionView, configWithModel model: Any, at indexPath: IndexPath)
    
    static func size(with collectionView: UICollectionView, section: NKCollectionSection, model: Any?) -> CGSize
}

