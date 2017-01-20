//
//  TestCollectionView.swift
//  NKit
//
//  Created by Nghia Nguyen on 1/19/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import Foundation
import UIKit

class TextCell: NKBaseCollectionViewCell, NKCollectionViewItemProtocol {
    
    typealias CollectionViewItemModel = String
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    override func setupView() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.nk_addSubview(self.label) {
            $0.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
                make.width.equalTo(NKScreenSize.Current.width)
            })
        }
    }
    
    func collectionView(collectionView: NKCollectionView, configWithModel model: CollectionViewItemModel, atIndexPath indexPath: IndexPath) {
        self.label.text = model
    }
}
struct ColorType {
    let color: UIColor
    let height: CGFloat
}
class ColorCell: NKBaseCollectionViewCell, NKCollectionViewItemProtocol {
    typealias CollectionViewItemModel = ColorType
    
    lazy var checkView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func setupView() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.nk_addSubview(self.checkView) {
            
            $0.snp.makeConstraints({ (make) in
                make.leading.trailing.equalToSuperview().inset(10)
                make.top.bottom.equalToSuperview().inset(10)
                make.width.equalTo(NKScreenSize.Current.width - 20)
                make.height.equalTo(0)
            })
//            $0
//                .nk_addSubview(UILabel()) {
//                    $0.text = "Nghia"
//                    $0.sizeToFit()
//                    $0.snp.makeConstraints({ (make) in
//                        make.top.leading.trailing.equalToSuperview()
//                    })
//            }
        }
    }
    
    func collectionView(collectionView: NKCollectionView, configWithModel model: ColorType, atIndexPath indexPath: IndexPath) {
//        self.view.backgroundColor = model
//        self.contentView.backgroundColor = model
        self.checkView.backgroundColor = model.color
        
        self.checkView.snp.updateConstraints { (make) in
            make.height.equalTo(model.height)
        }
    }
}

class TestCollectionViewController: UIViewController, NKCollectionViewDataSource {
    
    enum Id: String, NKViewIdentifier {
        case collectionView
    }
    
    lazy var collectionView: NKCollectionView = Id.collectionView.view(self)
    
    override func loadView() {
        super.loadView()
        
        self.view.nk_config({
            $0.backgroundColor = UIColor.white
        })
            .nk_addSubview(NKCollectionView.init(options: [.LineSpace(10), .ScrollDirection(.vertical), .ItemSize(NKCollectionViewAutoDimension)]).nk_id(Id.collectionView)) {
            $0.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            $0.backgroundColor = UIColor.white
            $0.registerView(ColorCell.self)
            $0.registerView(TextCell.self)
            $0.nk_dataSource = self
        }
    }
    
    func itemsForCollectionView(collectionView: NKCollectionView) -> [[Any]] {
        return [[ColorType.init(color: UIColor.green, height: 100), "Nghia", ColorType.init(color: UIColor.green, height: 100), "HieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieu", ColorType(color: UIColor.gray, height: 500),ColorType(color: UIColor.yellow, height: 700), ColorType(color: UIColor.purple, height: 150)]]
    }
}
