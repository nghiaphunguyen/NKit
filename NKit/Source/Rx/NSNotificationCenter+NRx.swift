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

public extension NotificationCenter {
    public static var nk_keyboardWillShowObservable: Observable<CGFloat> {
        return self.default.rx.notification(Notification.Name.UIKeyboardWillShow).map({
            let a = ($0.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.height
            return a
        })
    }
    
    public static var nk_keyboardWillHideObservable: Observable<CGFloat> {
        return self.default.rx.notification(Notification.Name.UIKeyboardWillHide).map({($0.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.height})
    }
    
    public static var nk_keyboardChangedHeightObservable: Observable<CGFloat> {
        
        let keyboardWillShow = self.default.rx.notification(Notification.Name.UIKeyboardWillShow).map({($0.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.height})
        let keyboardWillHide = self.default.rx.notification(Notification.Name.UIKeyboardWillHide).map {_ in return CGFloat(0)}
            
        return [keyboardWillShow, keyboardWillHide].toObservable().merge()
    }
}
