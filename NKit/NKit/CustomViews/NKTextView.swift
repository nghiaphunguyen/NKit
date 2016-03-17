//
//  NKTextView.swift
//
//  Created by Nghia Nguyen on 2/6/16.
//

import UIKit

public class NKTextView: UITextView, UITextViewDelegate {
    
    public typealias NKTextViewHandler = (textView: NKTextView) -> Void
    
    public var didBeginEditHandler: NKTextViewHandler?
    public var didEndEditHandler: NKTextViewHandler?
    
    public var placeholder: String? {
        didSet {
            self.checkAndTurnOnPlaceholder()
        }
    }
    
    public var placeholderColor: UIColor? {
        didSet {
            if self.isTurnOnPlaceholder {
                self.textColor = placeholderColor
            }
        }
    }
    
    public var contentTextColor: UIColor? {
        didSet {
            if !self.isTurnOnPlaceholder {
                self.textColor = contentTextColor
            }
        }
    }
    
    private var isTurnOnPlaceholder: Bool = false
    
    func checkAndTurnOnPlaceholder() {
        if self.text == "" {
            self.isTurnOnPlaceholder = true
            self.textColor = self.placeholderColor
            self.text = self.placeholder
        } else {
            self.isTurnOnPlaceholder = false
            self.textColor = self.contentTextColor
        }
    }
    
    override public var text: String? {
        didSet {
            super.text = self.text
            self.checkAndTurnOnPlaceholder()
        }
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
    public func textViewDidBeginEditing(textView: UITextView) {
        if self.isTurnOnPlaceholder {
            self.isTurnOnPlaceholder = false
            self.text = ""
            self.textColor = self.contentTextColor
        }
        
        didBeginEditHandler?(textView: self)
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        self.checkAndTurnOnPlaceholder()
        
        didEndEditHandler?(textView: self)

    }
}
