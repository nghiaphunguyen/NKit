//
//  NKCollectionViewDelegate.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/5/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

@objc public protocol NKCollectionViewDelegate: UICollectionViewDelegate {
    @objc optional func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool
    @objc optional func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}
