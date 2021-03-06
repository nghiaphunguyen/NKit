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
import OAStackView

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
                make.top.equalToSuperview().offset(offset)
                make.leading.equalToSuperview()
            })
        } else {
            view.snp.makeConstraints({ (make) in
                make.top.equalToSuperview().offset(offset)
                make.leading.equalToSuperview()
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
        
        controller.view.nk_addSubview(OAStackView.nk_row()) {
            $0.backgroundColor = UIColor.gray
            $0.alpha = 0.3
            
            let v = $0
            var offset: CGPoint?
            $0.rx_pan().bindNext({
                let location = $0.location(in: controller.view)
                
                if offset == nil {
                    offset = location
                    return
                }
                
                guard let off = offset else {return}

                let delta = CGPointMake(location.x - off.x, location.y - off.y)
                
                let newLeading = v.nk_x + delta.x
                let newTrailing = newLeading + v.nk_width
                let newTop = v.nk_y + delta.y
                let newBottom = newTop + v.nk_height
                
                guard newLeading >= 0
                    && newTrailing <= controller.view.nk_width
                    && newTop >= 0
                    && newBottom <= controller.view.nk_height else {
                    return
                }
                
                v.snp.remakeConstraints({ (make) in
                    make.leading.equalToSuperview().offset(v.nk_x + delta.x)
                    make.top.equalToSuperview().offset(v.nk_y + delta.y)
                })
                v.layoutIfNeeded()
                
                offset = location
            }).addDisposableTo(controller.nk_disposeBag)
            
            $0.snp.makeConstraints({ (make) in
                make.bottom.trailing.equalToSuperview().inset(20)
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
        
        let controller = self.init()
        controller.setupButtons(controller: controller)
        
        if self.shouldAddNavigationBar {
            return UINavigationController(rootViewController: controller)
        }
        
        return controller
    }
}
