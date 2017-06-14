//
//  NKBaseLoader.swift
//  NKit
//
//  Created by Apple on 3/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift

open class NKBaseLoader: NSObject, NKLoadable {
    open var rx_error = Variable<Error?>(nil)
    open var rx_isLoading = Variable<Bool>(false)
    
    open func clearError() {
        if self.rx_error.value != nil {
            self.rx_error.nk_asyncSet(value: nil)
        }
    }
    
    open func setupBeforeLoading() {
        if self.rx_isLoading.value != true {
            self.rx_isLoading.value = true
        }
    }
    
    open func resetAfterDone() {
        if self.rx_isLoading.value != false {
            self.rx_isLoading.value = false
        }
    }
}
