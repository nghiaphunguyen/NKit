//
//  NKTextView.swift
//
//  Created by Nghia Nguyen on 2/6/16.
//

import UIKit
import RxSwift
import RxCocoa

open class NKTextView: UITextView, UITextViewDelegate {
    
    private var _rx_didBeginEdit = Variable<Void>()
    private var _rx_didEndEdit = Variable<Void>()
    
    public var rx_didBeginEdit: Observable<Void> {
        return self._rx_didBeginEdit.asObservable()
    }
    
    public var rx_didEndEdit: Observable<Void> {
        return self._rx_didEndEdit.asObservable()
    }
    
    public var nk_text: String? = nil {
        didSet {
            self.updateText()
        }
    }
    
    open var nk_placeholder: String? {
        didSet {
            self.updateText()
        }
    }
    
    open var nk_placeholderColor: UIColor? {
        didSet {
            self.updateText()
        }
    }
    
    open var nk_contentTextColor: UIColor? {
        didSet {
            self.updateText()
        }
    }
    
    private var nk_isEditingMode: Bool = false
    
    private var nk_isTurnOnPlaceholder: Bool {
        return !self.nk_isEditingMode && self.nk_text?.isEmpty == true
    }
    
    open func updateText() {
        if self.nk_isTurnOnPlaceholder {
            self.text = self.nk_placeholder
            self.textColor = self.nk_placeholderColor
        } else {
            self.text = self.nk_text
            self.textColor = self.nk_contentTextColor
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero, textContainer: nil)
        self.setupView()
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() {
        self.delegate = self
        self.rx.text.subscribe(onNext: { [unowned self] in
            if self.nk_text != $0 && !self.nk_isTurnOnPlaceholder {
                self.nk_text = $0
            }
        }).addDisposableTo(self.nk_disposeBag)
        
        self.updateText()
    }
    
    //MARK: UITextViewDelegate
    open func textViewDidBeginEditing(_ textView: UITextView) {
        self.nk_isEditingMode = true
        
        self.updateText()
        
        self._rx_didBeginEdit.nk_reload()
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        self.nk_isEditingMode = false
        
        self.updateText()
        
        self._rx_didEndEdit.nk_reload()
    }
}
