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

public protocol NKLayoutModelable {
    associatedtype Model
    func config(_ model: Model)
    static var models: [Model] {get}
}

public extension NKLayoutTestable where Self: UIView {
    public static var viewController: UIViewController {
        let controller = UIViewController()
        let view = self.init()
        controller.view.addSubview(view)
        controller.view.backgroundColor = self.backgroundColor
        
        if self.size == CGSize.zero {
            view.snp.makeConstraints({ (make) in
                make.top.equalTo(0).offset(nk_statusBarHeight)
                make.leading.trailing.equalTo(0)
            })
        } else {
            view.snp.makeConstraints({ (make) in
                make.top.equalTo(0).offset(nk_statusBarHeight)
                make.leading.equalTo(0)
                make.size.equalTo(self.size)
            })
        }
        
        if self.shouldAddNavigationBar {
            return UINavigationController(rootViewController: controller)
        }
        
        return controller
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

public extension NKLayoutTestable where Self: UIView, Self: NKLayoutModelable {
    public static var viewController: UIViewController {
        let controller = UIViewController()
        let view = self.init()
        controller.view.addSubview(view)
        controller.view.backgroundColor = self.backgroundColor
        
        if self.size == CGSize.zero {
            view.snp.makeConstraints({ (make) in
                make.top.equalTo(0).offset(nk_statusBarHeight)
                make.leading.trailing.equalTo(0)
            })
        } else {
            view.snp.makeConstraints({ (make) in
                make.top.equalTo(0).offset(nk_statusBarHeight)
                make.leading.equalTo(0)
                make.size.equalTo(self.size)
            })
        }
        
        if self.shouldAddNavigationBar {
            return UINavigationController(rootViewController: controller)
        }
        
        let models = self.models
        var i = 0
        func setConfig(_ index: Int) {
            if (0..<models.count) ~= index {
                i = index
                view.config(models[i])
            }
        }
        
        controller.view.nk_addSubview(UIStackView.nk_row()) {
            $0.backgroundColor = UIColor.gray
            $0.alpha = 0.3
            $0.snp.makeConstraints( { (make) in
                make.bottom.trailing.equalTo(0).inset(20)
            })
            
            $0
                .nk_addArrangedSubview(UIButton()) {
                    $0.setTitle("-", for: .normal)
                    $0.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
                    $0.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                    $0.setTitleColor(UIColor.black, for: .normal)
                    $0.setBackgroundImage(UIImage.nk_fromColor(UIColor.blue), for: .highlighted)
                    
                    $0.rx.tap.bindNext({
                        setConfig(i - 1)
                    }).addDisposableTo(controller.nk_disposeBag)
                }
                .nk_addArrangedSubview(UIButton()) {
                    $0.setTitle("+", for: .normal)
                    $0.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
                    $0.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                    $0.setTitleColor(UIColor.black, for: .normal)
                    $0.setBackgroundImage(UIImage.nk_fromColor(UIColor.blue), for: .highlighted)
                    $0.rx.tap.bindNext({
                        setConfig(i + 1)
                    }).addDisposableTo(controller.nk_disposeBag)
            }
            
        }
        
        setConfig(0)
        
        
        return controller
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
