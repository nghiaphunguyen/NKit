//
//  OtherTestingCollectionReactor.swift
//  NKit
//
//  Created by Apple on 5/27/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift

//MARK: -------Reactable-------
protocol OtherTestingCollectionState {
    var itemsObservable: Observable<[NKDiffable]> {get}
}

protocol OtherTestingCollectionAction {
    func loadMore()
}

protocol OtherTestingCollectionReactable {
    var state: OtherTestingCollectionState {get}
    var action: OtherTestingCollectionAction {get}
}

//MARK: -------Reactor-------
final class OtherTestingCollectionReactor: NSObject {
    let packageItemCount = 1000
    var offset = 0
    let rx_items = Variable<[Int]>([])
}

//MARK: React
extension OtherTestingCollectionReactor: OtherTestingCollectionState {
    var itemsObservable: Observable<[NKDiffable]> {
        return self.rx_items.asObservable().map({ items in
            return items.map({
                return NumberTableViewCellModelImp(num: $0)
            })
        })
    }
}

extension OtherTestingCollectionReactor: OtherTestingCollectionAction {
    func loadMore() {
        let start = self.offset
        let end = start + packageItemCount
        self.offset = end
        self.rx_items.value = self.rx_items.value + (start..<end)
    }
}

extension OtherTestingCollectionReactor: OtherTestingCollectionReactable {
    var state: OtherTestingCollectionState {
        return self
    }
    
    var action: OtherTestingCollectionAction {
        return self
    }
}

//MARK: Creator
extension OtherTestingCollectionReactor {
    static func instance() -> OtherTestingCollectionReactor {
        return OtherTestingCollectionReactor()
    }
}
