//
//  UIViewController+ChildViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 6/28/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit

protocol Check {
    associatedtype State
    associatedtype Action
    
    var state: State {get}
    var action: Action {get}
}

protocol CheckState {
    var a: Int {get}
    
}

protocol CheckAction {
    
}


class CheckReactor<A, B> {
    typealias State = A
    typealias Action = B

    var state: State!
    var action: Action!
}

let b = CheckReactor<CheckState, CheckAction>()


public extension UIViewController {
    public func nk_addChildViewController(controller: UIViewController) {
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
    
    public func nk_removeFromParentViewController() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}


public extension UIViewController {
    public func nk_hideKeyboardWhenTappedOuside() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.nk_hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc public func nk_hideKeyboard() {
        self.view.endEditing(true)
    }
}
