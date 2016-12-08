//
//  NKLayoutTestable.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/23/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public protocol NKLayoutTestable {
    static var viewController: UIViewController { get }
    static var shouldAddNavigationBar: Bool {get}
    static var size: CGSize {get}
    static var backgroundColor: UIColor {get}
}

private extension NKLayoutTestable where Self: NKLayoutModelable {
    
}

public protocol NKLayoutModelable {
    associatedtype Model
    func config(_ model: Model)
    static var models: [Model] {get}
}

public extension NKLayoutTestable where Self: UIView {
   fileprivate static func createViewAndController() -> (Self, UIViewController) {
        let controller = UIViewController()
        let view = self.init()
        controller.view.addSubview(view)
        controller.view.backgroundColor = self.backgroundColor
        let offset: CGFloat = (self.shouldAddNavigationBar ? 44 : 0) + nk_statusBarHeight
        if self.size == CGSize.zero {
            view.snp.makeConstraints({ (make) in
                make.top.equalTo(0).offset(offset)
                make.leading.trailing.equalTo(0)
            })
        } else {
            view.snp.makeConstraints({ (make) in
                make.top.equalTo(0).offset(offset)
                make.leading.equalTo(0)
                make.size.equalTo(self.size)
            })
        }
        
        if self.shouldAddNavigationBar {
            return (view, UINavigationController(rootViewController: controller))
        }
        return (view, controller)
    }
    
    public static var viewController: UIViewController {
        return self.createViewAndController().1
    }
    
    public static var size: CGSize {
        return CGSize.zero
    }
    
    public static var backgroundColor: UIColor {
        return UIColor.white
    }
    
    public static var shouldAddNavigationBar: Bool {
        return false
    }
}

private extension NKLayoutTestable where Self: NKLayoutModelable {
    func setupButtons(controller: UIViewController) {
        let models = type(of: self).models
        var i = 0
        func setConfig(index: Int) {
            if (0..<models.count) ~= index {
                i = index
                self.config(models[i])
            }
        }
        
        controller.view.nk_addSubview(UIStackView.nk_row()) {
            $0.backgroundColor = UIColor.gray
            $0.alpha = 0.3
            $0.snp.makeConstraints({ (make) in
                make.bottom.trailing.equalTo(0).inset(20)
            })
            
            $0
                .nk_addArrangedSubview(UIButton()) {
                    $0.setTitle("<-", for: .normal)
                    $0.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
                    $0.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                    $0.setTitleColor(UIColor.black, for: .normal)
                    $0.setBackgroundImage(UIImage.nk_fromColor(UIColor.blue), for: .highlighted)
                    $0.rx.tap.bindNext({
                        setConfig(index: i - 1)
                    }).addDisposableTo(controller.nk_disposeBag)
                }
                .nk_addArrangedSubview(UIButton()) {
                    $0.setTitle("->", for: .normal)
                    $0.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
                    $0.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                    $0.setTitleColor(UIColor.black, for: .normal)
                    $0.setBackgroundImage(UIImage.nk_fromColor(UIColor.blue), for: .highlighted)
                    $0.rx.tap.bindNext({
                        setConfig(index: i + 1)
                    }).addDisposableTo(controller.nk_disposeBag)
            }
            
        }
        
        setConfig(index: 0)
    }
}

public extension NKLayoutTestable where Self: UIView, Self: NKLayoutModelable {
    public static var viewController: UIViewController {
        let viewAndController = self.createViewAndController()
        viewAndController.0.setupButtons(controller: viewAndController.1)
        
        return viewAndController.1
    }
}

public extension NKLayoutTestable where Self: UIViewController {
    public static var viewController: UIViewController {
        
        if self.shouldAddNavigationBar {
            return UINavigationController(rootViewController: self.init())
        }
        
        return self.init()
    }
    
    public static var shouldAddNavigationBar: Bool {
        return true
    }
    
    public static var size: CGSize {
        return NKScreenSize.Current
    }
    
    public static var backgroundColor: UIColor {
        return UIColor.white
    }
}

public extension NKLayoutTestable where Self: UIViewController, Self: NKLayoutModelable {
    public static var viewController: UIViewController {
        
        if self.shouldAddNavigationBar {
            return UINavigationController(rootViewController: self.init())
        }
        
        let controller = self.init()
        controller.setupButtons(controller: controller)
        return controller
    }
}
