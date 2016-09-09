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
        self.stackView.snp_makeConstraints { make in
            make.edges.equalTo(0)
            make.width.equalTo(self.stackView.superview!)
            make.height.equalTo(self.stackView.superview!)
        }
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.textField, self.textField1,
            self.textField2, self.textField3, self.textField4])
        stackView.alignment = .Fill
        stackView.distribution = .FillEqually
        stackView.axis = .Vertical
        stackView.spacing = 30
        return stackView
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.accessibilityIdentifier = "textField0"
        textField.backgroundColor = UIColor.blueColor()
        return textField
    }()
    
    lazy var textField1: UITextField = {
        let textField = UITextField()
        textField.accessibilityIdentifier = "textField1"
        textField.backgroundColor = UIColor.greenColor()
        return textField
    }()
    
    lazy var textField2: UITextField = {
        let textField = UITextField()
        textField.accessibilityIdentifier = "textField2"
        textField.backgroundColor = UIColor.grayColor()
        return textField
    }()
    
    lazy var textField3: UITextField = {
        let textField = UITextField()
        textField.accessibilityIdentifier = "textField3"
        textField.backgroundColor = UIColor.yellowColor()
        return textField
    }()
    
    lazy var textField4: UITextField = {
        let textField = UITextField()
        textField.accessibilityIdentifier = "textField4"
        textField.backgroundColor = UIColor.brownColor()
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.view.nk_autoHideKeyboardWhenTapOutside()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.nk_setBarTintColor(UIColor.whiteColor())
    }
}
