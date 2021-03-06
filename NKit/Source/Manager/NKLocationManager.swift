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
import NRxSwift
import RxCocoa

public protocol NKLocationState {
    var status: NKVariable<NKLocationStatus> {get}
    var currentLocations: NKVariable<[CLLocation]> {get}
}

public extension NKLocationState {
    public var currentLocation: NKVariable<CLLocation?> {
        return self.currentLocations.map { $0.first }
    }
}

public protocol NKLocationAction {
    func authorize()
    func getCurrentLocations() -> Observable<[CLLocation]>
}

public extension NKLocationAction {
    public func getCurrentLocation() -> Observable<CLLocation?> {
        return self.getCurrentLocations().map {$0.first}
    }
}

public protocol NKLocationReactable {
    var state: NKLocationState {get}
    var action: NKLocationAction {get}
}

public enum NKLocationStatus {
    case authorized
    case denied
    case notDetermined
    case off
}

public final class RxCLLocationManagerDelegate: DelegateProxy, DelegateProxyType, CLLocationManagerDelegate {
    public static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        return (object as? CLLocationManager)?.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        (object as? CLLocationManager)?.delegate = delegate as? CLLocationManagerDelegate
    }
}

public final class NKLocationManager: NSObject, NKLocationReactable, NKLocationAction, NKLocationState {

    
    public enum Err: Error {
        case unauthorized
    }
    
    public enum AuthorizeType {
        case whenInUse
        case always
        
        var status: CLAuthorizationStatus {
            switch self {
            case .whenInUse:
                return .authorizedWhenInUse
            case .always:
                return .authorizedAlways
            }
        }
    }
    
    fileprivate lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = kCLLocationAccuracyBest
        return manager
    }()
    
    
    fileprivate var rx_currentLocations = Variable<[CLLocation]>([])
    fileprivate lazy var rx_status: Variable<NKLocationStatus> = {
        return Variable<NKLocationStatus>(self.authStatus)
    }()
    
    public private(set) var type: AuthorizeType
    public private(set) var locationTimeout: TimeInterval
    
    public init(type: AuthorizeType = .whenInUse, locationTimeout: TimeInterval = 5) {
        self.type = type
        self.locationTimeout = locationTimeout
        super.init()
        
        self.locationManager.rx_changeAuthorizationStatus.map { (status) -> NKLocationStatus in
            switch status {
            case .denied, .restricted:
                return NKLocationStatus.denied
            case .notDetermined:
                return NKLocationStatus.notDetermined
            case .authorizedAlways:
                return self.type == .always ? NKLocationStatus.authorized : NKLocationStatus.denied
            case .authorizedWhenInUse:
                return self.type == .whenInUse ? NKLocationStatus.authorized : NKLocationStatus.denied
            }
            
        }.bindTo(self.rx_status).addDisposableTo(self.nk_disposeBag)
    }
}

public extension NKLocationManager {
    public var status: NKVariable<NKLocationStatus> {
        return self.rx_status.nk_variable
    }
    
    public var currentLocations: NKVariable<[CLLocation]> {
        return self.rx_currentLocations.nk_variable
    }
    
    public var state: NKLocationState {
        return self
    }
    
    public var action: NKLocationAction {
        return self
    }
    
    public func getCurrentLocations() -> Observable<[CLLocation]> {
        return self.checkAuthorize()
            .do(onNext: {self.locationManager.startUpdatingLocation()})
            .flatMapLatest({ _ in return self.locationManager.rx_didUpdateLocations.timeout(self.locationTimeout, scheduler: MainScheduler.instance).take(1)})
            .do(onNext: {self.rx_currentLocations.value = $0})
            .nk_doOnNextOrCompleteOrError({self.locationManager.stopUpdatingLocation()})
    }
    
    public func authorize() {
        if self.status.value == .notDetermined {
            self.requestAuthorize()
        }
    }
}

fileprivate extension NKLocationManager {
    
    var isAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == self.type.status
    }
    
    var isGPSEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    var authStatus: NKLocationStatus {
        if self.isGPSEnabled == false {
            return .off
        }
        
        if self.isAuthorized {
            return .authorized
        }
        
        if CLLocationManager.authorizationStatus() == .denied {
            return .denied
        }
        
        return .notDetermined
    }
    
    func requestAuthorize(){
        switch self.type {
        case .whenInUse:
            locationManager.requestWhenInUseAuthorization()
        case .always:
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func checkAuthorize() -> Observable<Void> {
        return Observable<Void>.nk_baseCreate { (observer) in
            if self.status.value == .authorized {
                observer.nk_setValue()
                return
            }
            
            observer.nk_setError(Err.unauthorized)
        }
    }
}
