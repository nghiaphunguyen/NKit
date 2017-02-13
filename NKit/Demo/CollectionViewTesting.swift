//
//  CollectionViewTesting.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/6/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit


class CollectionTestingViewController: UIViewController {
    
    enum Id: String, NKViewIdentifier {
        case collectionView
    }
    
    fileprivate lazy var collectionView: NKCollectionView = Id.collectionView.view(self)
    
    override func loadView() {
        super.loadView()
        
        self.view
        .nk_config {
            $0.backgroundColor = UIColor.white
        }
            .nk_addSubview(NKCollectionView.init(sectionOptions: [[.inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)), .lineSpacing(10)]]).nk_id(Id.collectionView)) {
                $0.paging = true
                let layout = ($0.collectionViewLayout as! UICollectionViewFlowLayout)
                layout.itemSize = CGSize(width: NKScreenSize.Current.width
                    , height: 50)
                layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                $0.register(cellType: StringCell.self)
                
                $0.backgroundColor = UIColor.white
                $0.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nk_delay(3) {
            self.collectionView.updateFirstSection(withModels: ["Nghia", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen", "Duyen"])
        }
        
//        nk_delay(6) {
//            self.collectionView.updateFirstSection(withModels: ["Nghia", "Hieu", "Ha"])
//        }
    }
}

class StringCell: NKBaseCollectionViewCell, NKListViewCellConfigurable {
    typealias ViewCellModel = String
    
    enum Id: String, NKViewIdentifier {
        case label
    }
    
    lazy var label: UILabel = Id.label.view(self)
    
    override func setupView() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.nk_addSubview(UILabel().nk_id(Id.label)) {
            $0.sizeToFit()
            $0.snp.makeConstraints({ (make) in
                make.width.equalTo(NKScreenSize.Current.width - 10)
                make.edges.equalToSuperview()
            })
        }
    }
    
    func collectionView(_ collectionView: NKCollectionView, configWithModel model: String, atIndexPath indexPath: IndexPath) {
        self.label.text = model
    }
    
    static func size(withCollectionView collectionView: NKCollectionView, section: NKCollectionSection, model: String) -> CGSize {
        let inset = section.inset(with: collectionView)
        let width = collectionView.nk_width - inset.left - inset.right
        
        return CGSize(width: width, height: 50)
    }
}


