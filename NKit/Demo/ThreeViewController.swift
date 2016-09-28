//
//  ThreeViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/26/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import NTZStackView

class ThreeViewController: UIViewController {
    enum ViewIdentifier: String, NKViewIdentifier {
        case StackView
        case FirstLabel
        case SecondLabel
        case ThirdLabel
        case Button
    }
    
    var stackView: TZStackView {return ViewIdentifier.StackView.view(self.view) }
    var firstLabel: UILabel {return ViewIdentifier.FirstLabel.view(self.view) }
    var secondLabel: UILabel {return ViewIdentifier.SecondLabel.view(self.view) }
    var thirdLabel: UILabel {return ViewIdentifier.ThirdLabel.view(self.view) }
    var button: UIButton {return ViewIdentifier.Button.view(self.view) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.button.rx_tap.bindNext {
            print("ok roi nhe")
        }.addDisposableTo(self.nk_disposeBag)
    }
}

//MARK: Layout
extension ThreeViewController {
    override func loadView() {
        super.loadView()
        
        self.view.nk_addSubview(TZStackView.nk_column().nk_id(ViewIdentifier.StackView)) {
            $0.distribution = .Fill
            $0.alignment = .Fill
                        
            $0.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(0).inset(10)
            })
            
            $0.nk_addArrangedSubview(UILabel(text: 30.nk_dummyString, isSizeToFit: true, alignment: .Left).nk_id(ViewIdentifier.FirstLabel)) {
//                $0.snp_updateConstraints(closure: { (make) in
//                    make.height.equalTo(100)
//                })
                
                $0.nka_height == 40
                
                $0.numberOfLines = 0
                $0.backgroundColor = UIColor.blueColor()
                }
                .nk_addArrangedSubview(UILabel(text: 200.nk_dummyString, isSizeToFit: true, alignment: .Left).nk_id(ViewIdentifier.SecondLabel)) {
                    $0.nka_weight = 0.1
                    $0.numberOfLines = 0
                    $0.backgroundColor = UIColor.greenColor()
                    
                }.nk_addArrangedSubview(UILabel(text: 2000.nk_dummyString, isSizeToFit: true, alignment: .Left).nk_id(ViewIdentifier.ThirdLabel)) {
                    $0.nka_weight = 0.2
                    $0.numberOfLines = 0
                    $0.backgroundColor = UIColor.redColor()
                }.nk_addArrangedSubview(UIButton().nk_id(ViewIdentifier.Button)) {
                    $0.nka_weight = 0.4
                    $0.setTitle("Ok nhe", forState: .Normal)
                    $0.setBackgroundImage(UIImage.nk_fromColor(UIColor.blueColor()), forState: .Normal)
                    
                }.nk_addArrangedSubview(UIView()) {
                    $0.backgroundColor = UIColor.brownColor()
                    
                    $0.nk_addSubview(UIView().nk_id("TestHangHo")) { view in
                        view.backgroundColor = UIColor.grayColor()
                        
                        view.snp_makeConstraints(closure: { (make) in
                            make.top.leading.bottom.equalTo(0)
                            make.width.equalTo(view.superview!).dividedBy(4)
                        })
                        }.nk_addSubview(UIView()) { (view) in
                            view.backgroundColor = UIColor.lightGrayColor()
                            view.snp_makeConstraints(closure: { (make) in
                                make.top.trailing.bottom.equalTo(view.superview!)
                                make.leading.equalTo(view.superview!.nk_findViewById("TestHangHo").snp_trailing)
                            })
                            
                        }
            }
            }.nk_config {
                $0.backgroundColor = UIColor.yellowColor()
        }.nk_map()
    }
}
