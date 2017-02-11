//
//  NKBaseTableSection.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/10/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

public enum NKBaseTableSectionOption {
    case header(NKListSupplementaryViewConfigurable.Type)
    case footer(NKListSupplementaryViewConfigurable.Type)
}

public class NKBaseTableSection: NKTableSection {
    public init(options: [NKBaseTableSectionOption]) {
        super.init()
        
        options.forEach({
            switch $0 {
            case .header(let config):
                self.update(header: config)
            case .footer(let config):
                self.update(footer: config)
            }
        })
    }
}
