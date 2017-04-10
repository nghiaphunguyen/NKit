//
//  NKBaseRowType.swift
//  NKit
//
//  Created by Apple on 3/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public protocol NKBaseRowType {
    var sender: AnyObject? {get}
    func setupBehaviour()
    func sendAction(_ action: NKAction?)
}

public extension NKBaseRowType where Self: UICollectionViewCell {
    public var sender: AnyObject? {
        return self.nk_collectionView
    }
    
    public var indexPath: IndexPath? {
        return self.nk_collectionView?.indexPath(for: self)
    }
}

public extension NKBaseRowType where Self: UITableViewCell {
    public var sender: AnyObject? {
        return self.nk_tableView
    }
    
    public var indexPath: IndexPath? {
        return self.nk_tableView?.indexPath(for: self)
    }
}
