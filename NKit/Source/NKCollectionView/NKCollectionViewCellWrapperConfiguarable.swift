//
//  NKCollectionViewCellConfigurable.swift
//  IgListKitExample
//
//  Created by Nghia Nguyen on 1/24/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

protocol NKCollectionViewCellWrapperConfigurable: NKResuableIdentifier, NKDetechable {
    func config(collectionView: UICollectionView, cell: UICollectionViewCell, model: Any, indexPath: IndexPath)
    
    func size(with collectionView: UICollectionView, section: NKCollectionSection, model: Any) -> CGSize
}

struct NKCollectionViewCellWrapperConfiguration<T: NKCollectionViewCellConfigurable>: NKCollectionViewCellWrapperConfigurable {
    
    let reuseIdentifier: String
    
    func isMe(_ model: Any) -> Bool {
        return (model as? T.CollectionViewItemModel) != nil
    }
    
    func config(collectionView: UICollectionView, cell: UICollectionViewCell, model: Any, indexPath: IndexPath) {
        if let cell = cell as? T, let model = model as? T.CollectionViewItemModel {
            cell.collectionView(collectionView, configWithModel: model, atIndexPath: indexPath)
        }
    }
    
    func size(with collectionView: UICollectionView, section: NKCollectionSection, model: Any) -> CGSize {
        
        guard let model = model as? T.CollectionViewItemModel else {return .zero}
        
        return T.size(with: collectionView, section: section, model: model)
    }
}
