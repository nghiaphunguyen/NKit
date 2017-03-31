////
////  TestLayoutViewController.swift
////  NKit
////
////  Created by Apple on 3/26/17.
////  Copyright © 2017 Nghia Nguyen. All rights reserved.
////
//
import UIKit
import OAStackView

class TestLayoutViewController: UIViewController {
    struct Style {
        static var view = UIView.self >> {
            $0.backgroundColor = UIColor.black
        }
    }
    
    enum Id: String, NKViewIdentifier {
        case view
    }
    
    override func loadView() {
        super.loadView()
        
        self.view
            <<< UIView() >>> {
                $0
                    <<< UIView() >>> {
                        $0
                            <<< UIView() ~ Style.view ~ Id.view >>> {
                                $0.nka_top == 10
                            }
                            <<< UIView()
                            <<< UIView()
                
            }
        }
    }
}
//
//    enum Id: String, NKViewIdentifier, NKStylable {
//        case view
//        
//        func style(_ model: Any) {
//            
//        }
//    }
//    
//    override func loadView() {
//        super.loadView()
//        
//        if #available(iOS 9.0, *) {
////            self.view
////            <<< UIView() ~ Id.view >>> {
////                $0
////                <<< NKStackView.nk_row() >>> {
////                    $0
////                    <<< UIView() >>> {
////                        $0.backgroundColor = UIColor.green
////                    }
////                    <<< UIView() >>> {
////                        $0.backgroundColor = UIColor.blue
////                        
////                        $0
////                        <<< NKStackView.nk_row() >>> {
////                            $0
////                            <<< UIView()
////                            <<< UIView() >>> {
////                                $0
////                                <<< UIView()
////                                <<< UIView()
////                                <<< UIView() >>> {
////                                    $0
////                                    <<< UIView()
////                                    <<< UIView()
////                                    <<< UIView() >>> {
////                                        $0
////                                        <<< NKStackView.nk_row() >>> {
////                                            $0
////                                            <<< UIView()
////                                        }
////                                    }
////                                }
////                            }
////                        }
////                    }
////                }
////                <<< UIView() >>> {
////                    $0.backgroundColor = UIColor.green
////                }
////                <<< UIView() >>> {
////                    $0.backgroundColor = UIColor.green
////                }
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//}
