//
//  HTTPLayer.swift
//  Weather
//
//  Created by Gio Lomsa on 6/25/19.
//  Copyright © 2019 Giorgi Lomsadze. All rights reserved.
//

import Foundation

class HTTPLayer{
    
    
    
//    https://openweathermap.org/current (api)
//    - https://samples.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=b6907d
//289e10d714a6e88b30761fae22 (weather per location with api key)
//    - http://openweathermap.org/img/w/10d.png (icon)
    
//    http://api.openweathermap.org/data/2.5/weather?id=2643743&appid=8709616a9d372207ada686ff175b754f
    
    
    //"id": 2643743,
//    "name": "London",
//    "country": "GB",
//    "coord": {
//    "lon": -0.12574,
//    "lat": 51.50853
//    }
    
    
//    "id": 1850147,
//    "name": "Tokyo",
//    "country": "JP",
//    "coord": {
//    "lon": 139.691711,
//    "lat": 35.689499
    
//    "id": 5110302,
//    "name": "Brooklyn",
//    "country": "US",
//    "coord": {
//    "lon": -73.949577,
//    "lat": 40.650101
//    }
    
    
    
    let baseURLString = "http://api.openweathermap.org/data/2.5/weather?"
    let iconBaseURL = "http://openweathermap.org/img/wn/"
    let iconExtension = "@2x.png"
    let apiKey = "&units=imperial&appid=8709616a9d372207ada686ff175b754f"
    let urlSession = URLSession.shared
    
//    http://openweathermap.org/img/wn/50n@2x.png
    enum HTTPMethod: String{
        case get    = "GET"
        case post   = "POST"
    }
    
    enum Endpoint{
        case weatherByCityId(String)
        case weatherByGeographicCoordinates(Double, Double)
        case weatherIcon(String)
        
        var path: String{
            switch self {
            case .weatherByCityId(let id):
                return "id=\(id)"
            case .weatherByGeographicCoordinates(let lat, let lon):
                return "lat=\(lat)&lon=\(lon)"
            case .weatherIcon(let iconName):
                return "\(iconName)"
            }
        }
    }
    
    func request(at endpoint: Endpoint, isIcon: Bool, completion: @escaping (Data?, URLResponse?, Error?)-> Void){
        var fullURLString = ""
        
        if isIcon{
            fullURLString = iconBaseURL + endpoint.path + iconExtension
        }else{
            fullURLString = baseURLString + endpoint.path + apiKey
        }
        print(fullURLString)
        let url = URL(string: fullURLString)
        let task = urlSession.dataTask(with: url!) { (data, response, error) in
            completion(data, response, error)
        }
        task.resume()
    }
}
