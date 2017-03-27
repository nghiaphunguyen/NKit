//
//  RowTableView.swift
//  Dealer
//
//  Created by Nghia Nguyen on 3/16/17.
//  Copyright © 2017 Replaid Pte Ltd. All rights reserved.
//

import UIKit

open class NKRowTableView: NKTableView {
    override open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if let value = self.nk_delegate?.tableView?(tableView, shouldHighlightRowAt: indexPath) {
            return value
        }
        
        return (tableView.cellForRow(at: indexPath) as? NKSelectionRowType) != nil
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = self.nk_delegate?.tableView?(tableView, didSelectRowAt: indexPath) {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? NKSelectionRowType else {return}
        
        cell.selectSubject.onNext()
    }
}
