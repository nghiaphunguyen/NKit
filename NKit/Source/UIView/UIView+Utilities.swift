//
//  UIView+Utilities.swift
//
//  Created by Nghia Nguyen on 12/7/15.
//

import UIKit
import RxSwift
import RxCocoa

public extension UIView {
    @objc public func nk_addTarget(_ target: Any, action: Selector, for event: UIControl.Event) {
        self.nk_addSubview(UIButton()) {
            $0.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            
            $0.addTarget(target, action: action, for: event)
        }
    }
    
    @objc public var nk_parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
    
    @objc @discardableResult public func nk_addBorder(borderWidth: CGFloat = 1,
                                                color: UIColor = UIColor.black,
                                                cornerRadius: CGFloat = 0) -> UIView {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        
        self.layer.cornerRadius = cornerRadius
        
        self.clipsToBounds = true
        
        return self
    }
    
    @objc @discardableResult public func nk_setBorderForAllSubviews() -> UIView {
        self.nk_addBorder(borderWidth: 1, color: UIColor.yellow)
        
        for view in self.subviews {
            view.nk_setBorderForAllSubviews()
        }
        
        return self
    }
    
    
    private static var materialBackgroundColors: [UIColor] { return [
        UIColor(hex: 0xF44336), UIColor(hex: 0xE91E63),
        UIColor(hex: 0x9C27B0), UIColor(hex: 0x673AB7),
        UIColor(hex: 0x3F51B5), UIColor(hex: 0x2196F3),
        UIColor(hex: 0x03A9F4), UIColor(hex: 0x00BCD4),
        UIColor(hex: 0x009688), UIColor(hex: 0x4CAF50),
        UIColor(hex: 0x8BC34A), UIColor(hex: 0xCDDC39),
        UIColor(hex: 0xFFEB3B), UIColor(hex: 0xFFC107),
        UIColor(hex: 0xFF9800), UIColor(hex: 0xFF5722),
        UIColor(hex: 0x795548), UIColor(hex: 0x9E9E9E)] }
    
    @objc public func nk_setBackgroundColorForAllSubviews() -> UIView {
        
        let colors = type(of: self).materialBackgroundColors
        var index = 0
        var k = 0
        let max = colors.count / 2
        func setBackgroundColor(view: UIView) {
            view.backgroundColor = colors[index + max * k]
            k = k ^ 1
            index = (index + 1) % max
            
            for subview in view.subviews {
                setBackgroundColor(view: subview)
            }
        }
        
        setBackgroundColor(view: self)
        
        return self
    }
    
    @objc public func nk_snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image!
    }
    
    @objc public var nk_tableView: UITableView? {
        return self.superView(withClass: UITableView.self) as? UITableView
    }
    
    @objc public var nk_collectionView: UICollectionView? {
        return self.superView(withClass: UICollectionView.self) as? UICollectionView
    }
    
    @objc public var nk_colletionViewCell: UICollectionViewCell? {
        return self.superView(withClass: UICollectionViewCell.self) as? UICollectionViewCell
    }
    
    @objc public var nk_tableViewCell: UITableViewCell? {
        return self.superView(withClass: UITableViewCell.self) as? UITableViewCell
    }
    
    private func superView(withClass clas: AnyClass) -> UIView? {
        var view = self.superview
        while view != nil && view?.isKind(of: clas) != true {
            view = view?.superview
        }
        
        return view
    }
}

public extension UIView {
    @objc public func nk_autoHideKeyboardWhenTapOutside() {
        self.rx_tap()
            .bindNext({[unowned self]_ in
                self.endEditing(true)})
            .addDisposableTo(self.nk_disposeBag)
    }
    
    @objc public var nk_firstSubviewResponse: UIView? {
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let v = view.nk_firstSubviewResponse {
                return v
            }
        }
        
        return nil
    }
    
    @objc public func nk_findAllSubviews(types: [AnyClass]) -> [UIView] {
        var result = [UIView]()
        
        if types.contains(where: {self.isKind(of: $0) })  {
            result += [self]
        }
        
        for view in self.subviews {
            result += view.nk_findAllSubviews(types: types)
        }
        return result
    }
}
