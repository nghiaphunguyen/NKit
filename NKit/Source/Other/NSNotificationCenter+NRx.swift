//
//  NSNotificationCenter+NRx.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/9/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import NRxSwift

public extension NSNotificationCenter {
    public static var nk_keyboardWillShowObservable: Observable<CGFloat> {
        return self.defaultCenter().rx_notification(UIKeyboardWillShowNotification).map({$0.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.height}).nk_unwrap()
    }
    
    public static var nk_keyboardWillHideObservable: Observable<CGFloat> {
        return self.defaultCenter().rx_notification(UIKeyboardWillHideNotification).map({$0.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.height}).nk_unwrap()
    }
    
    public static var nk_keyboardChangedHeightObservable: Observable<CGFloat> {
        let keyboardWillShow = self.defaultCenter().rx_notification(UIKeyboardWillShowNotification).map({$0.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.height}).nk_unwrap()
        let keyboardWillHide = self.defaultCenter().rx_notification(UIKeyboardWillHideNotification).map {_ in return CGFloat(0)}
        
        return [keyboardWillShow, keyboardWillHide].toObservable().merge()
    }
}