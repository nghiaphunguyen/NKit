//
//  NKLocationManager.swift
//  NKit
//
//  Created by Nghia Nguyen on 9/11/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

public final class NKLocationManager: AnyObject {
    
    public enum Error: ErrorType {
        case Unauthorized
        case GPSOff
    }
    
    public enum Status {
        case Authorized
        case Denied
        case NotDetermined
        case GPSOff
    }
    
    public enum AuthorizeType {
        case WhenInUse
        case Always
        
        var status: CLAuthorizationStatus {
            switch self {
            case .WhenInUse:
                return .AuthorizedWhenInUse
            case .Always:
                return .AuthorizedAlways
            }
        }
        
        func requestAuthorize(locationManager locationManager: CLLocationManager) -> Void {
            switch self {
            case .WhenInUse:
                locationManager.requestWhenInUseAuthorization()
            case .Always:
                locationManager.requestAlwaysAuthorization()
            }
        }
    }
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = kCLLocationAccuracyBest
        return manager
    }()
    
    
    private var latestLocation: CLLocation? = nil
    
    public private(set) var type: AuthorizeType
    public private(set) var authorizeTimeout: NSTimeInterval
    public private(set) var locationTimeout: NSTimeInterval
    
    public init(type: AuthorizeType = .WhenInUse, authorizeTimeout: NSTimeInterval = 5, locationTimeout: NSTimeInterval = 5) {
        self.type = type
        self.authorizeTimeout = authorizeTimeout
        self.locationTimeout = locationTimeout
    }
}

public extension NKLocationManager {
    public var nearestLocation: CLLocation? {
        if self.latestLocation == nil {
            return self.locationManager.location
        }
        
        return self.latestLocation
    }
    
    public var isAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == self.type.status
    }
    
    public var isGPSEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    public var status: Status {
        if self.isGPSEnabled == false {
            return .GPSOff
        }
        
        if self.isAuthorized {
            return .Authorized
        }
        
        if CLLocationManager.authorizationStatus() == .Denied {
            return .Denied
        }
        
        return .NotDetermined
    }
    
    public var currentLocations: Observable<[CLLocation]> {
        return self.checkGPS()
            .flatMapLatest({_ in return self.checkAuthorize() })
            .doOnNext {self.locationManager.startUpdatingLocation()}
            .flatMapLatest({ _ in return self.locationManager.rx_didUpdateLocations.timeout(self.locationTimeout, scheduler: MainScheduler.instance)})
            .doOnNext({self.latestLocation = $0.first})
            .nk_doOnNextOrError({self.locationManager.stopUpdatingLocation()})
    }
    
    public var currentLocation: Observable<CLLocation> {
        return self.currentLocations.map {$0.first}.nk_unwrap()
    }
    
    public func authorize() -> Observable<Void> {
        return Observable<Void>.nk_baseCreate { (observer) in
            if self.isAuthorized {
                observer.nk_setValue()
                return
            }
            
            self.type.requestAuthorize(locationManager: self.locationManager)
            
            nk_delay(self.authorizeTimeout) {
                if self.isAuthorized {
                    observer.nk_setValue()
                } else {
                    observer.nk_setError(Error.Unauthorized)
                }
            }
        }
    }
}

private extension NKLocationManager {
    func checkGPS() -> Observable<Void> {
        return Observable<Void>.nk_baseCreate({ (observer) in
            guard self.isGPSEnabled else {
                observer.nk_setError(Error.GPSOff)
                return
            }
            
            observer.nk_setValue()
        })
    }
    
    func checkAuthorize() -> Observable<Void> {
        return Observable<Void>.nk_baseCreate { (observer) in
            if self.isAuthorized {
                observer.nk_setError(Error.Unauthorized)
                return
            }
            
            observer.nk_setValue()
        }
    }
}