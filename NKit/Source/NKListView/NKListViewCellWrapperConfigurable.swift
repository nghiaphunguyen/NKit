//
//  NKListViewCellWrapperConfigurable.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/10/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

protocol NKListViewCellWrapperConfigurable: NKResuableIdentifier, NKDetechable {
    func config(listView: NKListView, cell: UIView, model: Any, indexPath: IndexPath)
    
    func size(with listView: NKListView, section: NKListSection, model: Any) -> NKSize
}

struct NKListViewCellWrapperConfiguration<T: NKListViewCellConfigurable>: NKListViewCellWrapperConfigurable {
    
    let reuseIdentifier: String
    
    func isMe(_ model: Any) -> Bool {
        return (model as? T.ViewCellModel) != nil
    }
    
    func config(listView: NKListView, cell: UIView, model: Any, indexPath: IndexPath) {
        if let cell = cell as? T, let model = model as? T.ViewCellModel {
            cell.listView(listView, configWithModel: model, atIndexPath: indexPath)
        }

    }
    
    func size(with listView: NKListView, section: NKListSection, model: Any) -> NKSize {
        guard let model = model as? T.ViewCellModel else {return CGSize.zero}
        
        return T.size(with: listView, section: section, model: model)
    }
}

