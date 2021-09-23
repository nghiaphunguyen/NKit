//
//  PullingTestingReactor.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/19/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift

final class PullingTestingReactor: NKBasePullingViewModel {
    
    override func pull() -> Observable<[Any]> {
        if page < 3 {
        return Observable<[String]>.nk_baseCreate({ (observer) in
            nk_delay(3) {
                observer.nk_setValue(["NghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghiaNghia", "HieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieuHieu", "HaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHaHa"])
            }
        }).map {$0.nk_any}
        }
        
        return Observable.just([])
    }
    
    override func map(value: Any) -> NKDiffable {
        return value as! NKDiffable
    }
    
    override func getInitPage() -> Int {
        return 1
    }
    
    override func errorString(error: Error) -> String {
        return "Error"
    }
}

extension PullingTestingReactor: PullingTestingState {
}

extension PullingTestingReactor: PullingTestingAction {
    
}

extension PullingTestingReactor: PullingTestingReactable {
    var state: PullingTestingState {
        return self
    }
    
    var action: PullingTestingAction {
        return self
    }
}


