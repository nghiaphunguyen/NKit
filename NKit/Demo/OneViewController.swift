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
        
        self.view
            .nk_config() {
                $0.backgroundColor = UIColor.green
                $0.nk_autoHideKeyboardWhenTapOutside()
            }
            
            .nk_addSubview(NKTextView()) {
                $0.nk_placeholder = "Placeholder"
                
                $0.snp.makeConstraints({ (make) in
                    make.top.leading.equalToSuperview()
                    make.height.equalTo(100)
                    make.width.equalTo(100)
                })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //print("oneViewWillAppear with navigationItem=\(self.navigationController?.navigationItem) leftButton=\(self.navigationController?.navigationItem.leftBarButtonItem)")
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
