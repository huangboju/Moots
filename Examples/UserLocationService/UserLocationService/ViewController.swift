//
//  ViewController.swift
//  UserLocationService
//
//  Created by xiAo_Ju on 2019/4/3.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit
import CoreLocation

//class ViewController: UIViewController {
//
//    var locationManager: CLLocationManager
//    var userLocation: CLLocation?
//
//    init(locationProvider: CLLocationManager = CLLocationManager()) {
//        self.locationManager = locationProvider
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        locationManager.delegate = self
//    }
//
//    func requestUserLocation() {
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
//}
//
//extension ViewController: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            manager.startUpdatingLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        userLocation = locations.last
//        manager.stopUpdatingLocation()
//    }
//}

class ViewControllerWithoutCL: UIViewController {
    
    var locationProvider: UserLocationProvider
    var userLocation: UserLocation?
    
    init(locationProvider: UserLocationProvider) {
        self.locationProvider = locationProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func requestUserLocation() {
        locationProvider.findUserLocation { [weak self] location, error in
            if error == nil {
                self?.userLocation = location
            } else {
                print("User can not be located 😔")
            }
        }
    }
}
