//
//  SecondViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 8/26/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SecondViewController: UIViewController {
    
    lazy var button: UIButton = {
       let button = UIButton(title: "nghia")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor()
        
        self.view.addSubview(self.button)
        self.button.snp_makeConstraints { (make) in
            make.center.equalTo(0)
        }
        
        self.button.rx_tap.bindNext {
            self.navigationController?.pushViewController(TestingCollectionViewController(), animated: true)
        }.addDisposableTo(self.nk_disposeBag)
    }
}