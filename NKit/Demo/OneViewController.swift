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
import OAStackView

class OneViewController: UIViewController {
    
    enum Id: String, NKViewIdentifier {
        case pushButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.yellowColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("oneViewWillAppear with navigationItem=\(self.navigationController?.navigationItem) leftButton=\(self.navigationController?.navigationItem.leftBarButtonItem)")
        self.nk_setBarTintColor(UIColor.greenColor()).nk_setRightBarButton("TwoView", selector: #selector(OneViewController.gotoTwoView))
        
        self.nk_setBackBarButton(text: "", color: nil)
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationController?.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.view.layoutIfNeeded()
    }
    
    func gotoTwoView() {
        self.navigationController?.pushViewController(TwoViewController(), animated: true)
    }
    
}