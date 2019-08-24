//
//  MainViewModel.swift
//  Weather
//
//  Created by Gio Lomsa on 6/26/19.
//  Copyright © 2019 Giorgi Lomsadze. All rights reserved.
//

import Foundation
import UIKit

class MainViewModel{
    
    // Create Notification for weather model change
    static let currentLocationweatherChangeNotification = Notification.Name(rawValue: "gio.lomsa.CurrentLocationWeatherChange")
    static let weatherArrayChangeNotification = Notification.Name(rawValue: "gio.lomsa.WeatherArrayChange")
    //
    
    var currentCityWeather: Weather?{
        didSet{
            // Post Notification
            NotificationCenter.default.post(name: MainViewModel.currentLocationweatherChangeNotification, object: nil)
        }
    }
    var weatherArrayWithoutCurrentCity = [Weather](){
        didSet{
            // Post Notification
            NotificationCenter.default.post(name: MainViewModel.weatherArrayChangeNotification, object: nil)
        }
    }
    
    private let locationManager = CoreLocationManager()
    private let imageCache = NSCache<NSString, UIImage>()

    
    // TODO:- Make cities editable for user
    private let cities = ["London":"2172797", "Tokyo":"1850147"]
    
    func getWeatherFromServer(){
        DispatchQueue.global(qos: .background).async {
            self.getWeatherByGeoLocation()
            self.getWeatherByCityName()
        }
        
    }
    
    func getWeatherByGeoLocation(){
        self.locationManager.getCurrentLocation {(latitude, longitude) in
            let lat = latitude ?? 40.7128
            let lon = longitude ?? 74.0060
                
            let httpLayer = HTTPLayer()
            let apiClient = APIClient(httpLayer: httpLayer)
            
            apiClient.getWeatherByGeoLocation(latitude: lat, longitude: lon, completion: {[weak self] (result) in
                switch result{
                case .success(let weather):
                    print(weather.id)
                    self?.currentCityWeather = weather
                case .failure(let error):
                    print(error)
                    // Show error alert
                    return
                }
            })
        }
    }
    
    private func getWeatherByCityName(){
        let httpLayer = HTTPLayer()
        let apiClient = APIClient(httpLayer: httpLayer)
        for city in cities{
            apiClient.getWeatherByCityId(city: city.value) {[weak self] (result) in
                
                switch result{
                case .success(let weather):
                    print(weather)
                    self?.weatherArrayWithoutCurrentCity.append(weather)
                case .failure(let error):
                    print(error)
                    // Show error alert
                    return
                }
            }
        }
    }

    func getIcon(for icon: String, completion: @escaping(UIImage)->Void){
        let httpLayer = HTTPLayer()
        let apiClient = APIClient(httpLayer: httpLayer)
        var image = UIImage()
        
        if let cachedImage = self.imageCache.object(forKey: NSString(string: icon )){
            print("Image From Cach")
            completion(cachedImage)
        }else{
            apiClient.downloadIcon(for: icon) { (result) in
                switch result{
                case .success(let imageData):
                    image = UIImage(data: imageData)!
                    self.imageCache.setObject(image, forKey: NSString(string: icon))
                    print("Image From URL")
                    completion(image)
                case .failure(let error):
                    print(error)
                    //TODO:- Show error alert
                    return
                }
            }
        }
    }
}

