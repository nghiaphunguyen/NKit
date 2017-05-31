//
//  NumberTableViewCell.swift
//  NKit
//
//  Created by Apple on 5/27/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

//MARK: -------Model-------
protocol NumberTableViewCellModel: NKDiffable {
    var num: Int {get}
    
}

extension NumberTableViewCellModel {
    var diffIdentifier: String {
        return num.nk_string
    }
}

struct NumberTableViewCellModelImp: NumberTableViewCellModel {
    var num: Int
}

//MARK: -------Cell-------
final class NumberTableViewCell: NKBaseCollectionViewCell {
    fileprivate lazy var label: UILabel = Id.label.view(self)
}

//MARK: Layout
extension NumberTableViewCell {
    fileprivate enum Id: String, NKViewIdentifier {
        case label
    }
    
    fileprivate struct Style {
        
    }

    override func setupView() {
        self.contentView.nk_addSubview(UILabel() ~ Id.label) {
            $0.sizeToFit()
            $0.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview().inset(5)
            })
        }
    }
}

//MARK: Action
extension NumberTableViewCell {
    override func setupRx() {

    }
}

extension NumberTableViewCell: NKListViewCellConfigurable {
    typealias ViewCellModel = NumberTableViewCellModel

    func collectionView(_ collectionView: NKCollectionView, configWithModel model: NumberTableViewCellModel, atIndexPath indexPath: IndexPath) {
            self.label.text = model.num.nk_string
    }
    
    static func size(withCollectionView collectionView: NKCollectionView, section: NKCollectionSection, model: NumberTableViewCellModel) -> CGSize {
        return CGSize(width: 50, height: 50)
    }

}

//MARK: Testing
extension NumberTableViewCell: NKLayoutTestable {}

extension NumberTableViewCell: NKLayoutModelable {
    typealias Model = NumberTableViewCellModel

    func config(_ model: Model) {
    }

    static var models: [Model] {
        return []
    }
}
