//
//  NKStackView.swift
//  NKit
//
//  Created by Nghia Nguyen on 4/9/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import Foundation
import TZStackView

//MARK: - NKStackViewItemProtocol
public protocol NKStackViewItemProtocol: NSObjectProtocol {
    typealias StackViewModel
    func stackView(stackView: NKStackView, configViewWithModel model: StackViewModel)
}

public protocol NKStackViewDataSource: NSObjectProtocol {
    func stackViewItems(stackView: NKStackView) -> [Any]
}

//MARK: - Properties
public class NKStackView: NKBaseView {
    //Private properties
    private typealias ConfigViewBlock = (view: UIView, model: Any) -> Void
    
    private lazy var stackView: TZStackView = {
       let stackView = TZStackView()
        return stackView
    }()
    
    private lazy var modelViewTypeMapping = [String: (viewType: UIView.Type, configViewBlock: ConfigViewBlock)]()
    
    //Public properties
    public weak var dataSource: NKStackViewDataSource?
    
    public var spacing: CGFloat {
        get {
            return self.stackView.spacing
        }
        set {
            self.stackView.spacing = newValue
        }
    }
    
    public var axis: UILayoutConstraintAxis {
        get {
            return self.stackView.axis
        }
        
        set {
            self.stackView.axis = newValue
        }
    }
    
    public var alignment: TZStackViewAlignment {
        get {
            return self.stackView.alignment
        }
        
        set {
            self.stackView.alignment = newValue
        }
    }
    
    public var distribution: TZStackViewDistribution {
        get {
            return self.stackView.distribution
        }
        
        set {
            self.stackView.distribution = newValue
        }
    }
    
    //Layout
    public override func setupView() {
        self.addSubview(self.stackView)
        
        self.stackView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
    }
}

//MARK: - Public functions
public extension NKStackView {
    public func reload(animate animate: Bool = false, duration: NSTimeInterval = 1) {
        guard let dataSource = self.dataSource else {
            return
        }
        
        let action = {
            let items = dataSource.stackViewItems(self)
            
            for (index, item) in items.enumerate() {
                guard let mapping = self.modelViewTypeMapping["\(item.dynamicType.self)"] else {
                    continue
                }
                
                let addNewViewToStackViewAtIndex: (index: Int) -> UIView = { (index) in
                    let view = mapping.viewType.init()
                    self.stackView.insertArrangedSubview(view, atIndex: index)
                    return view
                }
                
                let view: UIView
                if self.stackView.arrangedSubviews.count > index {
                    if self.stackView.arrangedSubviews[index].isKindOfClass(mapping.viewType)  {
                        view = self.stackView.arrangedSubviews[index]
                    } else {
                        // remove view at index
                        let preview = self.stackView.arrangedSubviews[index]
                        self.stackView.removeArrangedSubview(preview)
                        preview.removeFromSuperview()
                        
                        view = addNewViewToStackViewAtIndex(index: index)
                    }
                } else {
                    view = addNewViewToStackViewAtIndex(index: index)
                }
                
                mapping.configViewBlock(view: view, model: item)
            }
            
            var redundantItemCount = self.stackView.arrangedSubviews.count - items.count
            while redundantItemCount > 0 {
                let view = self.stackView.arrangedSubviews[self.stackView.arrangedSubviews.count - 1]
                self.stackView.removeArrangedSubview(view)
                view.removeFromSuperview()
                redundantItemCount -= 1
            }
        }
        
        if animate {
            UIView.animateWithDuration(duration, animations: { () -> Void in
                action()
            })
        } else {
            action()
        }
    }
    
    public func registerView<T: UIView where T: NKStackViewItemProtocol>(type: T.Type) {
        let modelName = "\(type.StackViewModel.self)"
        
        self.modelViewTypeMapping[modelName] = (viewType: type, configViewBlock: {[weak self] (view, model) in
            guard let strongSelf = self else {
                return
            }
            if let view = view as? T, model = model as? T.StackViewModel {
                view.stackView(strongSelf, configViewWithModel: model)
            }
            })
    }
}