//
//  ForurViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/30/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

class FourViewController: UIViewController, NKCollectionViewDataSource {
    
    var model = [1,2,3,4]
    
    lazy var collectionView: NKCollectionView = {
        let collectionView = NKCollectionView(options: [
            .ItemSize(CGSizeMake(NKScreenSize.Current.width - 20, NKScreenSize.Current.height * 0.8)),
            .SectionInset(UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)),
            .LineSpace(30),
            .ScrollDirection(.vertical)
            ]).nk_id("collectionView")
        collectionView.registerView(CollectionViewCell2.self)
        collectionView.nk_dataSource = self
    
        collectionView.nk_paging = true
        collectionView.backgroundColor = UIColor.brown
        
        return collectionView
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view
            .nk_config() {
                $0.backgroundColor = UIColor.green
            }
            
            .nk_addSubview(self.collectionView) {
                $0.snp.makeConstraints({ (make) in
                    make.leading.trailing.equalTo(0)
                    make.top.bottom.equalTo(0).inset(20)
                })
            }
        
        nk_delay(5) {
            print("Stop paging")
            self.collectionView.nk_paging = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func itemsForCollectionView(collectionView: NKCollectionView) -> [[Any]] {
        return [self.model.map {$0 as Any}]
    }
}

class CollectionViewCell2: NKBaseCollectionViewCell, NKCollectionViewItemProtocol {
    open func collectionView(collectionView: NKCollectionView, configWithModel model: Int, atIndexPath indexPath: IndexPath) {
    }

    typealias CollectionViewItemModel = Int
    
    override func setupView() {
        self.backgroundColor = UIColor.blue
    }
}
