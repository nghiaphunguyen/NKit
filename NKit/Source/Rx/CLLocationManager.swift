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

public extension CLLocationManager {
    public var rx_didUpdateLocations: Observable<[CLLocation]> {
        return self.rx.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))).map { $0.map {$0 as! CLLocation} }
    }
}
