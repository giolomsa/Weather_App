//
//  HTTPLayer.swift
//  Weather
//
//  Created by Gio Lomsa on 6/25/19.
//  Copyright © 2019 Giorgi Lomsadze. All rights reserved.
//

import Foundation

class HTTPLayer{
    
    let baseURLString = "http://api.openweathermap.org/data/2.5/weather?"
    let iconBaseURL = "http://openweathermap.org/img/wn/"
    let iconExtension = "@2x.png"
    let apiKey = "&units=imperial&appid=8709616a9d372207ada686ff175b754f"
    let urlSession = URLSession.shared
    
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
