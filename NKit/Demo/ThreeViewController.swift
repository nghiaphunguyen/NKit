//
//  ThreeViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/26/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit


class ThreeViewController: UIViewController {
    enum ViewIdentifier: String, NKViewIdentifier {
        case StackView
        case FirstLabel
        case SecondLabel
        case ThirdLabel
        case Button
    }
    
    var stackView: UIStackView {return ViewIdentifier.StackView.view(self) }
    var firstLabel: UILabel {return ViewIdentifier.FirstLabel.view(self) }
    var secondLabel: UILabel {return ViewIdentifier.SecondLabel.view(self) }
    var thirdLabel: UILabel {return ViewIdentifier.ThirdLabel.view(self) }
    var button: UIButton {return ViewIdentifier.Button.view(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.button.rx.tap.bindNext {
            //print("ok")
            }.addDisposableTo(self.nk_disposeBag)
    }
}

//MARK: Layout
extension ThreeViewController {
    override func loadView() {
        super.loadView()

        
        self.view
            .nk_config() {
                $0.backgroundColor = UIColor.black
            }

            .nk_addSubview(UIView()) {
                $0.nk_id = ""

                $0
                .nk_addSubview(UIView()) {

                    $0
                    .nk_addSubview(UIView()) {
                        $0.nk_id = ""
                    }

                    .nk_addSubview(UIView()) {
                        $0.nk_id = ""
                    }
                }

                .nk_addSubview(UIView()) {

                    $0
                    .nk_addSubview(UIView()) {
                        $0.nk_id = ""
                    }
                }
            }

            .nk_addSubview(UIView()) {
                $0.nk_id = ""
            }.nk_mapIds()
        

        //        self.view > UIView() * {
        //            $0.nk_id = nil
        //            } > UIView() * {
        //                $0.nk_id = nil
        //        }
        
//        self.view.nk_config {
//                $0.backgroundColor = UIColor.yellowColor()
//            }.add_subviews()UIStackView.nk_column().nk_id(ViewIdentifier.StackView) >>> {
//                $0.distribution = .Fill
//                $0.alignment = .Fill
//                
//                $0.snp.makeConstraints(closure: { (make) in
//                    make.top.equalToSuperview().inset(20)
//                    make.leading.trailing.bottom.equalToSuperview().inset(10)
//                })
//                
//                $0
//                    <<< UILabel(text: 30.nk_dummyString, isSizeToFit: true, alignment: .Left).nk_id(ViewIdentifier.FirstLabel) >>> {
//                    $0.nka_height == $0.nka_width / 4
//                    
//                    $0.numberOfLines = 0
//                    $0.backgroundColor = UIColor.blueColor()
//                    }
//                    
//                    <<< UILabel(text: 200.nk_dummyString, isSizeToFit: true, alignment: .Left).nk_id(ViewIdentifier.SecondLabel) >>> {
//                        $0.nka_weight = 0.1
//                        $0.numberOfLines = 0
//                        $0.backgroundColor = UIColor.greenColor()
//                        
//                    }
//                    
//                    <<< (UILabel(text: 2000.nk_dummyString, isSizeToFit: true, alignment: .Left).nk_id(ViewIdentifier.ThirdLabel) >>> {
//                        $0.nka_weight = 0.55
//                        $0.numberOfLines = 0
//                        $0.backgroundColor = UIColor.redColor()
//                    }
//                        
//                    <<< (UIButton().nk_id(ViewIdentifier.Button)) >>> {
//                        $0.nka_weight = 0.1
//                        $0.setTitle("Ok nhe", forState: .Normal)
//                        $0.setBackgroundImage(UIImage.nk_fromColor(UIColor.blueColor()), forState: .Normal)
//                        
//                    }
//                    <<< (UIView()) >>> {
//                        $0.backgroundColor = UIColor.brownColor()
//                        
//                        $0.nk_addSubview(UIView().nk_id("TestHangHo")) { view in
//                            view.backgroundColor = UIColor.grayColor()
//                            
//                            view.snp.makeConstraints(closure: { (make) in
//                                make.top.leading.bottom.equalToSuperview()
//                                make.width.equalTo(view.superview!).dividedBy(4)
//                            })
//                            }.nk_addSubview(UIView()) { (view) in
//                                view.backgroundColor = UIColor.lightGrayColor()
//                                view.snp.makeConstraints(closure: { (make) in
//                                    make.top.trailing.bottom.equalTo(view.superview!)
//                                    make.leading.equalTo(view.superview!.nk_findViewById("TestHangHo").snp.trailing)
//                                })
//                                
//                        }
//                    }
        }
}
