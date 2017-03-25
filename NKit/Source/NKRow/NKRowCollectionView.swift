//
//  RowCollectionView.swift
//  Dealer
//
//  Created by Nghia Nguyen on 3/16/17.
//  Copyright © 2017 Replaid Pte Ltd. All rights reserved.
//

import UIKit

open class NKRowCollectionView: NKCollectionView {
    open override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if let value = self.nk_delegate?.collectionView?(collectionView, shouldHighlightItemAt: indexPath) {
            return value
        }
        
        return (collectionView.cellForItem(at: indexPath) as? NKSelectionRowType) != nil
    }
    
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = self.nk_delegate?.collectionView?(collectionView, didSelectItemAt: indexPath) {
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? NKSelectionRowType else {return}
        cell.selectSubject.onNext()
    }
    
}
