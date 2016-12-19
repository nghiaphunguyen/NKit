//
//  NKModelConfig.swift
//  NKit
//
//  Created by Nghia Nguyen on 12/13/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

protocol NKCollectionViewCellConfigurable {
    var reuseIdentifier: String {get}
    
    func isMe(model: Any) -> Bool
    func config(collectionView: NKCollectionView, cell: UICollectionViewCell, model: Any, indexPath: IndexPath)
}

struct NKCollectionViewCellConfigure<T: NKCollectionViewItemProtocol>: NKCollectionViewCellConfigurable {
    
    let reuseIdentifier: String
    
    func isMe(model: Any) -> Bool {
        return (model as? T.CollectionViewItemModel) != nil
    }
    
    func config(collectionView: NKCollectionView, cell: UICollectionViewCell, model: Any, indexPath: IndexPath) {
        if let view = cell as? T, let model = model as? T.CollectionViewItemModel {
            view.collectionView(collectionView: collectionView, configWithModel: model, atIndexPath: indexPath)
        }
    }
}
