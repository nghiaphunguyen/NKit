//
//  NKPresentRowType.swift
//  Dealer
//
//  Created by Nghia Nguyen on 3/14/17.
//  Copyright © 2017 Replaid Pte Ltd. All rights reserved.
//

import UIKit
import RxSwift

public enum NKPresentMode {
    case push
    case present
}

public protocol NKPresentRowType: NKBaseRowType {
    var toViewController: NKCallbackable? {get}
    var fromViewController: UIViewController? {get}
    var presentMode: NKPresentMode {get}
    var selectSubject: PublishSubject<Void> {get}
    func handleCallback(withPayload payload: Any)
    func present(toViewController: UIViewController, from fromViewController: UIViewController)
    var canPresent: Bool {get}
}

extension NKPresentRowType where Self: UIView {
    public var canPresent: Bool {
        return true
    }
    
    public var fromViewController: UIViewController? {
        return self.nk_parentViewController
    }
    
    public func present(toViewController: UIViewController, from fromViewController: UIViewController) {
        switch self.presentMode {
        case .present:
            fromViewController.present(toViewController, animated: true, completion: nil)
        case .push:
            fromViewController.nk_nearestNavigationController?.pushViewController(toViewController, animated: true)
        }
    }
    
    public func setupBehaviour() {
        self.selectSubject.asObservable().nk_subscribe { [weak self] in
            guard let strongSelf = self else {return}
            guard strongSelf.canPresent else {return}
            
            guard var callbackable = strongSelf.toViewController else {return}
            callbackable.callback = strongSelf.handleCallback
            
            guard let fromViewController = strongSelf.fromViewController, let toViewController = callbackable as? UIViewController else {
                return
            }
            
            strongSelf.present(toViewController: toViewController, from: fromViewController)
            
            }.addDisposableTo(self.nk_disposeBag)
    }
}
