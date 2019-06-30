//
//  Weather.swift
//  Weather
//
//  Created by Gio Lomsa on 6/25/19.
//  Copyright © 2019 Giorgi Lomsadze. All rights reserved.
//

import Foundation
struct Weather: Decodable{
    
    // City details
    var id:                     Int
    var cityName:               String
    
    // Weather details
    var weatherName:            String
    var weatherDescription:     String
    var weatherIconName:         String
    
    // Temperature details
    var temperature:            Double
    var pressure:               Int
    var humidity:               Int
    var minTemp:                Double
    var maxTemp:                Double
    
    // Wind details
    var windSpeed:              Double
    var windDeg:                Int
    
    // cloud details
    var clouds:                 Int
    
    // Initialization from dictrionary
    init(jsonData:[String: Any]) {
        
        self.id = jsonData["id"] as? Int ?? 0
        self.cityName = jsonData["name"] as? String ?? ""
        
        if let weatherDeatailsArray = jsonData["weather"] as? [[String:Any]],
            !weatherDeatailsArray.isEmpty{
            let weatherDeatails = weatherDeatailsArray[0]
            self.weatherName = weatherDeatails["main"] as? String ?? ""
            self.weatherDescription = weatherDeatails["description"] as? String ?? ""
            self.weatherIconName = weatherDeatails["icon"] as? String ?? "defaultIcon.png"
        }else{
            self.weatherName = "Unknown"
            self.weatherDescription = "Unknown"
            self.weatherIconName = "Unknown"
        }
        
        if let weatherConditionDetails = jsonData["main"] as? [String: Any]{
            self.temperature = weatherConditionDetails["temp"] as? Double ?? 0.0
            self.pressure = weatherConditionDetails["pressure"] as? Int ?? 0
            self.humidity = weatherConditionDetails["humidity"] as? Int ?? 0
            self.minTemp = weatherConditionDetails["temp_min"] as? Double ?? 0.0
            self.maxTemp = weatherConditionDetails["temp_max"] as? Double ?? 0.0
        }else{
            self.temperature = 0.0
            self.pressure = 0
            self.humidity = 0
            self.minTemp = 0.0
            self.maxTemp = 0.0
        }
        
        if let windDetails = jsonData["wind"] as? [String: Any]{
            self.windSpeed = windDetails["speed"] as? Double ?? 0.0
            self.windDeg = windDetails["deg"] as? Int ?? 0
        }else{
            self.windSpeed = 0.0
            self.windDeg = 0
        }
        
        if let cloudDetails = jsonData["clouds"] as? [String: Any]{
            self.clouds = cloudDetails["all"] as? Int ?? 0
        }else{
            self.clouds = 0
        }
        
    }
    
}
