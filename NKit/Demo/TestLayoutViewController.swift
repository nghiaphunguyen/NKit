////
////  TestLayoutViewController.swift
////  NKit
////
////  Created by Apple on 3/26/17.
////  Copyright © 2017 Nghia Nguyen. All rights reserved.
////
//
//import UIKit
//
//class TestLayoutViewController: UIViewController {
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
