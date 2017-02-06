//
//  TwoViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/12/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

final class TwoViewController: UIViewController {
    
    enum Id: String, NKViewIdentifier {
        case scrollView
    }
    
    private lazy var scrollView: UIScrollView = Id.scrollView.view(self)
    
    private lazy var popAnimator: NKAnimator = self.setupPopAnimator()
    private func setupPopAnimator() -> NKAnimator {
        let animator = NKAnimator.pop(duration: 1, animationType: NKAnimator.AnimationType.Interactive) { (context) in
            let fromView = context.fromView
            UIView.animate(withDuration: context.duration, animations: {
                fromView.nk_y = -NKScreenSize.Current.height
                }, completion:  { _ in
                    context.completeTransition()
            })
        }
        
        return animator
    }
    
    override func loadView() {
        super.loadView()
        
        self.view
            .nk_config {
                $0.backgroundColor = UIColor.blue
            }
            .nk_addSubview(UIScrollView().nk_id(Id.scrollView)) {
            $0.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            
            $0.nk_addSubview(UIView()) {
                $0.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                    make.height.equalTo(make.nk_view.superview!).multipliedBy(2)
                    make.width.equalTo(make.nk_view.superview!)
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.nk_transition[NKAnyViewController.self << self] = self.popAnimator
        self.navigationController?.delegate = self.navigationController?.nk_transition
        
        self.setupPopInteractive()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.nk_setBarTintColor(UIColor.clear).nk_setLeftBarButton("back")
        self.navigationItem.hidesBackButton = true
                //print("twoViewWillAppear with navigationItem=\(self.navigationController?.navigationItem) leftButton=\(self.navigationController?.navigationItem.leftBarButtonItem)")
        self.navigationController?.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.view.layoutIfNeeded()
    }
    
    func setupPopInteractive() {
        
        var startPan: CGFloat = -1
        self.scrollView.panGestureRecognizer.rx.event.bindNext { [unowned self] (gesture) in
            let position = gesture.location(in: self.view.window!)
            let percent = max(0, min(1, (startPan - position.y) / 500))
            
            switch gesture.state {
            case .began, .changed:
                
                //print("Pan gesture change: \(position.y)")
                let contentOffsetY = self.scrollView.contentOffset.y
                let maxContentOffsetY = self.scrollView.contentSize.height - self.scrollView.nk_height
                
                guard contentOffsetY >= maxContentOffsetY else {
                    return
                }
                
                if startPan == -1 {
                    //print("Start pop: \(position.y)")
                    self.popAnimator.startInteractiveTransition()
                    startPan = position.y
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
                //print("Change pop interactive percent: \(percent)")
                self.popAnimator.updateInteractiveTransition(percentComplete: percent)
            case .cancelled:
                //print("Cancel pan gesture")
                self.popAnimator.cancelInteractiveTransition()
                startPan = -1
            case .ended:
                //print("End pan gesture")
                let velocity = gesture.velocity(in: self.view.window!)
                if percent >= 1 || percent > 0.3 && velocity.y < -100 {
                    self.popAnimator.finishInteractiveTransition()
                } else {
                    self.popAnimator.cancelInteractiveTransition()
                }
                
                startPan = -1
            default:
                break
            }
            
            }.addDisposableTo(self.nk_disposeBag)
    }
}
