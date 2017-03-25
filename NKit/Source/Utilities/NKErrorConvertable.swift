//
//  NKErrorConvertable.swift
//  NKit
//
//  Created by Apple on 3/25/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit

import RxSwift

public protocol NKErrorConvertable {
    static func from(error: Error) -> Self?
}

public extension Observable {
    func nk_convertError<T: NKErrorConvertable>(errorType: T.Type) -> Observable<Element> {
        return self.catchError({
            let error = (errorType.from(error: $0) as? Error) ?? $0
            return Observable<Element>.error(error)
        })
    }
}
