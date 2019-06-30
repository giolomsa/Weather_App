//
//  CoreLocationManager.swift
//  Weather
//
//  Created by Gio Lomsa on 6/26/19.
//  Copyright © 2019 Giorgi Lomsadze. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class CoreLocationManager: UIViewController{
    
    static let locationManagerAuthorizarionStatus   = Notification.Name("gio.lomsa.locationManagerAuthStatusChanged")
    let locationManager                             = CLLocationManager()
    
    func getCurrentLocation(completion: @escaping(Double?, Double?)->Void){
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
            if let lat = locationManager.location?.coordinate.latitude,
                let lon = locationManager.location?.coordinate.longitude{
                completion(lat, lon)
            }else{
                completion(nil,nil)
            }
        }
    }
}

extension CoreLocationManager:  CLLocationManagerDelegate{
    // Notify viewmodel authorization status change
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            NotificationCenter.default.post(name: CoreLocationManager.locationManagerAuthorizarionStatus, object: nil)
//            print("Authorization changed")
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        NotificationCenter.default.post(name: CoreLocationManager.locationManagerAuthorizarionStatus, object: nil)
//        print("User exit the region")
    }
}
