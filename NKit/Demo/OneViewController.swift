//
//  OneViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/11/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

class OneViewController: UIViewController {
    
    enum Id: String, NKViewIdentifier {
        case pushButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.yellow
        
        self.view
            .nk_addSubview(UITextView()) {
                $0.isScrollEnabled = false
//                $0.text = "Nghia"
                $0.snp.makeConstraints({ (make) in
                    make.top.leading.trailing.equalToSuperview()
                })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("oneViewWillAppear with navigationItem=\(self.navigationController?.navigationItem) leftButton=\(self.navigationController?.navigationItem.leftBarButtonItem)")
        self.nk_setBarTintColor(UIColor.green).nk_setRightBarButton("TwoView", selector: #selector(OneViewController.gotoTwoView))
        
        self.nk_setBackBarButton(text: "", color: nil)
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationController?.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.view.layoutIfNeeded()
    }
    
    func gotoTwoView() {
        self.navigationController?.pushViewController(TwoViewController(), animated: true)
    }
    
}
