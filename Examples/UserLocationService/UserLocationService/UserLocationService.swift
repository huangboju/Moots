//
//  UserLocationService.swift
//  UserLocationService
//
//  Created by xiAo_Ju on 2019/4/3.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit
import CoreLocation

typealias Coordinate = CLLocationCoordinate2D

protocol UserLocation {
    var coordinate: Coordinate { get }
}

extension CLLocation: UserLocation { }

enum UserLocationError: Swift.Error {
    case canNotBeLocated
}

typealias UserLocationCompletionBlock = (UserLocation?, UserLocationError?) -> Void

protocol UserLocationProvider {
    func findUserLocation(then: @escaping UserLocationCompletionBlock)
}

protocol LocationProvider {
    var isUserAuthorized: Bool { get }
    func requestWhenInUseAuthorization()
    func requestLocation()
}

extension CLLocationManager: LocationProvider {
    var isUserAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
}

class UserLocationService: NSObject {
    fileprivate var provider: LocationProvider
    fileprivate var locationCompletionBlock: UserLocationCompletionBlock?
    
    init(with provider: LocationProvider) {
        self.provider = provider
        super.init()
    }
    
    func findUserLocation(then: @escaping UserLocationCompletionBlock) {
        self.locationCompletionBlock = then
        if provider.isUserAuthorized {
            provider.requestLocation()
        } else {
            provider.requestWhenInUseAuthorization()
        }
    }
}

extension UserLocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            provider.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let location = locations.last {
            locationCompletionBlock?(location, nil)
        } else {
            locationCompletionBlock?(nil, .canNotBeLocated)
        }
    }
}

struct UserLocationMock: UserLocation {
    var coordinate: Coordinate {
        return Coordinate(latitude: 51.509865, longitude: -0.118092)
    }
}

class UserLocationProviderMock: UserLocationProvider {
    
    var locationBlockLocationValue: UserLocation?
    var locationBlockErrorValue: UserLocationError?
    
    func findUserLocation(then: @escaping UserLocationCompletionBlock) {
        then(locationBlockLocationValue, locationBlockErrorValue)
    }
}

class LocationProviderMock: LocationProvider {
    
    var isRequestWhenInUseAuthorizationCalled = false
    var isRequestLocationCalled = false
    
    var isUserAuthorized: Bool = false
    
    func requestWhenInUseAuthorization() {
        isRequestWhenInUseAuthorizationCalled = true
    }
    
    func requestLocation() {
        isRequestLocationCalled = true
    }
}
