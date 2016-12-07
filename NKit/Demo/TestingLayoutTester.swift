//
//  TestingLayoutTester.swift
//  NKit
//
//  Created by Nghia Nguyen on 12/7/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

class TestView: NKBaseView {
    
    private enum Id: String, NKViewIdentifier {
        case titleLabel
    }
    
    private lazy var titleLabel: UILabel = Id.titleLabel.view(self)
    
    override func setupView() {
        self.nk_addSubview(UILabel(text: nil, isSizeToFit: true, alignment: .Center).nk_id(Id.titleLabel)) {
            $0.textColor = UIColor.blackColor()
            $0.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(0)
            })
        }
    }
}


extension TestView: NKLayoutTestable {}

extension TestView: NKLayoutModelable {
    typealias Model = String
    static var models: [Model] {
        return ["Nghia", "Hieu"]
    }
    
    func config(model: Model) {
        self.titleLabel.text = model
    }
}
