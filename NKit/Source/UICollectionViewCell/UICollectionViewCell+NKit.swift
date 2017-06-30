//
//  UICollectionViewCell+NKit.swift
//  NKit
//
//  Created by Apple on 6/30/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit


public extension UICollectionViewCell {
    public var nk_listView: NKListView? {
        return self.nk_collectionView as? NKListView
    }
}
