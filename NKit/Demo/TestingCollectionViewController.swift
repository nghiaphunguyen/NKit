//
//  TestingCollectionViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 8/26/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

final class TestingCollectionViewController: UIViewController {
    
    let model: [String] = ["Nghia" * 10, "Nghia" * 15, "Nghia" * 20, "Nghia" * 25, "Nghia" * 30, "Nghia" * 35, "Nghia" * 100, "Nghia" * 100, "Nghia" * 100, "Nghia" * 100, "Nghia" * 100, "Nghia" * 100]
    
    let collectionView: NKCollectionView = {
       let collectionView = NKCollectionView(options: [
        .AutoFitCell(CGSize(width: NKScreenSize.Current.width, height: 1),  .Height)
        ])
        
        collectionView.registerView(CollectionViewCell.self)
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.collectionView.nk_dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension TestingCollectionViewController: NKCollectionViewDataSource {
    func itemsForCollectionView(collectionView: NKCollectionView) -> [[Any]] {
        return [model.map {$0 as Any}]
    }
}

final class CollectionViewCell: NKBaseCollectionViewCell {
    var titleLabel: UILabel = {
        let label = UILabel(text: "", isSizeToFit: true, alignment: .left)
        label.numberOfLines = 0
        return label
    }()
    
    override func setupView() {
        self.nk_borderColor = UIColor.black
        self.nk_borderWidth = 1
        self.backgroundColor = UIColor.blue
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension CollectionViewCell: NKCollectionViewItemProtocol {
    typealias CollectionViewItemModel = String
    func collectionView(collectionView: NKCollectionView, configWithModel model: CollectionViewItemModel, atIndexPath indexPath: IndexPath) {
        self.titleLabel.text = model + "(\(model.characters.count))"
    }
}
