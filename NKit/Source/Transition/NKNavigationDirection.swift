//
//  NKNavigationDirection.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/13/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit

public typealias NKAnyViewController = UIViewController

public func >>(left: UIViewController, right: UIViewController) -> NKNavigationDirection {
    return type(of: left).self >> type(of: right).self
}

public func >>(left: UIViewController, right: UIViewController.Type) -> NKNavigationDirection {
    return type(of: left).self >> right
}

public func >>(left: UIViewController.Type, right: UIViewController) -> NKNavigationDirection {
    return left >> type(of: right).self
}

public func >>(left: UIViewController.Type, right: UIViewController.Type) -> NKNavigationDirection {
    return NKNavigationDirection(source: left, destination: right, operation: .push)
}

public func <<(left: UIViewController, right: UIViewController) -> NKNavigationDirection {
    return type(of: left).self << type(of: right).self
}

public func <<(left: UIViewController.Type, right: UIViewController) -> NKNavigationDirection {
    return left << type(of: right).self
}

public func <<(left: UIViewController, right: UIViewController.Type) -> NKNavigationDirection {
    return type(of: left).self << right
}

public func <<(left: UIViewController.Type, right: UIViewController.Type) -> NKNavigationDirection {
    return NKNavigationDirection(source: right, destination: left, operation: .pop)
}

public struct NKNavigationDirection {
    let source: UIViewController.Type
    let destination: UIViewController.Type
    let operation: UINavigationControllerOperation
}

extension NKNavigationDirection: Hashable {
    public var hashValue: Int {
        return "\(source)-\(destination)-\(operation)".hashValue
    }
}

public func ==(lhs: NKNavigationDirection, rhs: NKNavigationDirection) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
