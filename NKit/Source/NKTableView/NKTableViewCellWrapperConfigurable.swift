//
//  NKTableViewCellWrapperConfigurable.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/9/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

protocol NKTableViewCellWrapperConfigurable: NKResuableIdentifier, NKDetechable {
    func config(tableView: UITableView, cell: UITableViewCell, model: Any, indexPath: IndexPath)
    
    func height(with tableView: UITableView, section: NKTableSection, model: Any) -> CGFloat
}

struct NKTableViewCellWrapperConfiguration<T: NKTableViewCellConfigurable>: NKTableViewCellWrapperConfigurable {
    
    let reuseIdentifier: String
    
    func isMe(_ model: Any) -> Bool {
        return (model as? T.TableViewItemModel) != nil
    }
    
    func config(tableView: UITableView, cell: UITableViewCell, model: Any, indexPath: IndexPath) {
        if let cell = cell as? T, let model = model as? T.TableViewItemModel {
            cell.tableView(tableView, configWithModel: model, atIndexPath: indexPath)
        }
    }
    
    func height(with tableView: UITableView, section: NKTableSection, model: Any) -> CGFloat {
        
        guard let model = model as? T.TableViewItemModel else {return 0}
        
        return T.height(with: tableView, section: section, model: model)
    }
}

