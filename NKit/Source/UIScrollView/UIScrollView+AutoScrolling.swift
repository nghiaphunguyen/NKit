//
//  NKKeyboardManager.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/9/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public extension UIScrollView {
    public func nk_autoSrollWithKeyboardBehaviour(offsetY: CGFloat = 10) {
        
        var keyboardPreviousHeight: CGFloat = 0
        
        NSNotificationCenter.nk_keyboardChangedHeightObservable.bindNext {[unowned self] (height) in
            var contentInset = self.contentInset
            contentInset.bottom += (height - keyboardPreviousHeight)
            self.contentInset = contentInset
            
            keyboardPreviousHeight = height
        }.addDisposableTo(self.nk_disposeBag)
        
        NSNotificationCenter.nk_keyboardWillShowObservable.bindNext {[unowned self] (height) in
            guard let firstResponse = self.nk_firstSubviewResponse, window = self.window else {
                return
            }
            
            let keyboardOffsetY = NKScreenSize.Current.height - height
            
            let viewFrame = firstResponse.nk_convertFrameToView(window)
            let viewBottomY = viewFrame.origin.y + viewFrame.size.height
            
            let deltaY = (viewBottomY + offsetY) - keyboardOffsetY
            
            if deltaY > 0 {
                var contentOffset = self.contentOffset
                contentOffset.y += deltaY
                self.setContentOffset(contentOffset, animated: true)
            }
            
        }.addDisposableTo(self.nk_disposeBag)
    }
}