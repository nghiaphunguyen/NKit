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
            UIView.animateWithDuration(context.duration, animations: {
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
                $0.backgroundColor = UIColor.blueColor()
            }
            .nk_addSubview(UIScrollView().nk_id(Id.scrollView)) {
            $0.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(0)
            })
            
            $0.nk_addSubview(UIView()) {
                $0.snp_makeConstraints(closure: { (make) in
                    make.edges.equalTo(0)
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.nk_setBarTintColor(UIColor.clearColor()).nk_setLeftBarButton("back")
        self.navigationItem.hidesBackButton = true
                print("twoViewWillAppear with navigationItem=\(self.navigationController?.navigationItem) leftButton=\(self.navigationController?.navigationItem.leftBarButtonItem)")
        self.navigationController?.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.view.layoutIfNeeded()
    }
    
    func setupPopInteractive() {
        
        var startPan: CGFloat = -1
        self.scrollView.panGestureRecognizer.rx_event.bindNext { [unowned self] (gesture) in
            let position = gesture.locationInView(self.view.window!)
            let percent = max(0, min(1, (startPan - position.y) / 500))
            
            switch gesture.state {
            case .Began, .Changed:
                
                print("Pan gesture change: \(position.y)")
                let contentOffsetY = self.scrollView.contentOffset.y
                let maxContentOffsetY = self.scrollView.contentSize.height - self.scrollView.nk_height
                
                guard contentOffsetY >= maxContentOffsetY else {
                    return
                }
                
                if startPan == -1 {
                    print("Start pop: \(position.y)")
                    self.popAnimator.startInteractiveTransition()
                    startPan = position.y
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
                print("Change pop interactive percent: \(percent)")
                self.popAnimator.updateInteractiveTransition(percent)
            case .Cancelled:
                print("Cancel pan gesture")
                self.popAnimator.cancelInteractiveTransition()
                startPan = -1
            case .Ended:
                print("End pan gesture")
                let velocity = gesture.velocityInView(self.view.window!)
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