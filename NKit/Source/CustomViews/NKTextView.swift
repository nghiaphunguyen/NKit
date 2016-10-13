//
//  NKTextView.swift
//
//  Created by Nghia Nguyen on 2/6/16.
//

import UIKit

open class NKTextView: UITextView, UITextViewDelegate {
    
    public typealias NKTextViewHandler = (_ textView: NKTextView) -> Void
    
    open var didBeginEditHandlers = [NKTextViewHandler]()
    open var didEndEditHandlers = [NKTextViewHandler]()
    
    open func addDidBeginEditHandler(handler: @escaping NKTextViewHandler) {
        self.didBeginEditHandlers.append(handler)
    }
    
    open func addDidEndEditHandler(handler: @escaping NKTextViewHandler) {
        self.didEndEditHandlers.append(handler)
    }
    
    open var placeholder: String? {
        didSet {
            self.checkAndTurnOnPlaceholder()
        }
    }
    
    open var placeholderColor: UIColor? {
        didSet {
            if self.isTurnOnPlaceholder {
                self.textColor = placeholderColor
            }
        }
    }
    
    open var contentTextColor: UIColor? {
        didSet {
            if !self.isTurnOnPlaceholder {
                self.textColor = contentTextColor
            }
        }
    }
    
    open var isTurnOnPlaceholder: Bool = false
    
    @discardableResult open func checkAndTurnOnPlaceholder() -> NKTextView {
        if self.text == "" {
            self.isTurnOnPlaceholder = true
            self.textColor = self.placeholderColor
            self.text = self.placeholder
        } else {
            self.isTurnOnPlaceholder = false
            self.textColor = self.contentTextColor
        }
        
        return self
    }
    
    override open var text: String? {
        didSet {
            if self.text == self.placeholder {
                self.isTurnOnPlaceholder = true
                self.textColor = self.placeholderColor
            } else {
                self.isTurnOnPlaceholder = false
                self.textColor = self.contentTextColor
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero, textContainer: nil)
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
        self.checkAndTurnOnPlaceholder()
    }
    
    //MARK: UITextViewDelegate
    open func textViewDidBeginEditing(_ textView: UITextView) {
        if self.isTurnOnPlaceholder {
            self.isTurnOnPlaceholder = false
            self.text = ""
            self.textColor = self.contentTextColor
        }
        
        self.didBeginEditHandlers.forEach { (handler) -> () in
            handler(self)
        }
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        self.checkAndTurnOnPlaceholder()
        
        self.didEndEditHandlers.forEach { (handler) -> () in
            handler(self)
        }
        
    }
}
