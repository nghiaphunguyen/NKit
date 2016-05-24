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
        
        let action = {[weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let items = dataSource.stackViewItems(strongSelf)
            
            for (index, item) in items.enumerate() {
                guard let mapping = strongSelf.modelViewTypeMapping["\(item.dynamicType.self)"] else {
                    continue
                }
                
                let addNewViewToStackViewAtIndex: (index: Int) -> UIView = { (index) in
                    let view = mapping.viewType.init()
                    strongSelf.stackView.insertArrangedSubview(view, atIndex: index)
                    return view
                }
                
                let view: UIView
                if strongSelf.stackView.arrangedSubviews.count > index {
                    if strongSelf.stackView.arrangedSubviews[index].isKindOfClass(mapping.viewType)  {
                        view = strongSelf.stackView.arrangedSubviews[index]
                    } else {
                        // remove view at index
                        let preview = strongSelf.stackView.arrangedSubviews[index]
                        strongSelf.stackView.removeArrangedSubview(preview)
                        preview.removeFromSuperview()
                        
                        view = addNewViewToStackViewAtIndex(index: index)
                    }
                } else {
                    view = addNewViewToStackViewAtIndex(index: index)
                }
                
                view.hidden = false
                mapping.configViewBlock(view: view, model: item)
            }
            
            if (items.count > 0) {
                // add a fake view to prepare show animate
                if let mapping = strongSelf.modelViewTypeMapping["\(items[items.count - 1].dynamicType.self)"] where strongSelf.stackView.arrangedSubviews.count == items.count {
                    let view = mapping.viewType.init()
                    view.hidden = true
                    strongSelf.stackView.insertArrangedSubview(view, atIndex: items.count)
                }
            }
            
            var redundantItemCount = strongSelf.stackView.arrangedSubviews.count - 1 - items.count
            while redundantItemCount > 0 {
                let view = strongSelf.stackView.arrangedSubviews[strongSelf.stackView.arrangedSubviews.count - 1]
                strongSelf.stackView.removeArrangedSubview(view)
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