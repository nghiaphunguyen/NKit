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
        .LineSpace(5),
        .AutoFitCell(CGSizeMake(NKScreenSize.Current.width / 2 - 10, 1), .Height)
        ])
        
        collectionView.registerView(CollectionViewCell.self)
        collectionView.backgroundColor = UIColor.whiteColor()
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        self.collectionView.nk_dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.nk_setBarTintColor(UIColor.blueColor()).nk_setLeftBarButton("Back")
    }
}

extension TestingCollectionViewController: NKCollectionViewDataSource {
    func itemsForCollectionView(collectionView: NKCollectionView) -> [[Any]] {
        return [model.map {$0 as Any}]
    }
}

final class CollectionViewCell: NKBaseCollectionViewCell {
    var titleLabel: UILabel = {
        let label = UILabel(text: "", isSizeToFit: true, alignment: .Left)
        label.numberOfLines = 0
        return label
    }()
    
    override func setupView() {
        self.nk_borderColor = UIColor.blackColor()
        self.nk_borderWidth = 1
        self.backgroundColor = UIColor.blueColor()
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
}

extension CollectionViewCell: NKCollectionViewItemProtocol {
    typealias CollectionViewItemModel = String
    func collectionView(collectionView: NKCollectionView, configWithModel model: CollectionViewItemModel, atIndexPath indexPath: NSIndexPath) {
        self.titleLabel.text = model + "(\(model.characters.count))"
    }
}
