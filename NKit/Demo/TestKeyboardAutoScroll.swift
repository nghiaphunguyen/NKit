//
//  TestKeyboardAutoScroll.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/9/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import SnapKit

class TestKeyboardAutoScrollingViewController: UIViewController {
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.nk_autoSrollWithKeyboardBehaviour()
        view.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.edges.equalTo(0)
            make.width.equalTo(self.stackView.superview!)
            make.height.equalTo(self.stackView.superview!)
        }
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.textField, self.textField1,
            self.textField2, self.textField3, self.textField4])
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.accessibilityIdentifier = "textField0"
        textField.backgroundColor = UIColor.blue
        return textField
    }()
    
    lazy var textField1: UITextField = {
        let textField = UITextField()
        textField.accessibilityIdentifier = "textField1"
        textField.backgroundColor = UIColor.green
        return textField
    }()
    
    lazy var textField2: UITextField = {
        let textField = UITextField()
        textField.accessibilityIdentifier = "textField2"
        textField.backgroundColor = UIColor.gray
        return textField
    }()
    
    lazy var textField3: UITextField = {
        let textField = UITextField()
        textField.accessibilityIdentifier = "textField3"
        textField.backgroundColor = UIColor.yellow
        
        
        return textField
    }()
    
    lazy var textField4: UITextField = {
        let textField = UITextField()
        textField.accessibilityIdentifier = "textField4"
        textField.backgroundColor = UIColor.brown
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = self.nk_setBarTintColor(UIColor.white)
        
        self.view.backgroundColor = UIColor.black
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(0)
            make.top.equalTo(0)
        }
        self.view.nk_autoHideKeyboardWhenTapOutside()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _ = self.nk_setBarTintColor(UIColor.white)
    }
}
