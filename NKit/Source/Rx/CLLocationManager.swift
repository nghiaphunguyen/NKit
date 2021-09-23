//
//  CLLocationManager.swift
//  NKit
//
//  Created by Nghia Nguyen on 11/3/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

//public extension CLLocationManager {
//    public var rx_delegate: DelegateProxy<AnyObject, Any> {
//        return RxCLLocationManagerDelegate.proxyForObject(self)
//    }
//    
//    public var rx_didUpdateLocations: Observable<[CLLocation]> {
//        return self.rx_delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))).map { $0[1] as? [CLLocation]}.nk_unwrap()
//    }
//    
//    public var rx_changeAuthorizationStatus: Observable<CLAuthorizationStatus> {
//        return self.rx_delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:))).map { ($0[1] as? Int32).flatMap {CLAuthorizationStatus.init(rawValue: $0)} }.nk_unwrap()
//    }
//}
