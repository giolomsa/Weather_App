//
//  Weather.swift
//  Weather
//
//  Created by Gio Lomsa on 6/25/19.
//  Copyright © 2019 Giorgi Lomsadze. All rights reserved.
//

import Foundation

struct Weather: Codable{
    
    struct WeatherInfoContainer: Codable{
        var main: String
        var description: String
        var icon: String
    }
    
    // City details
    var id:                     Int
    var cityName:               String
    
    var weatherDetailsContainer: [WeatherInfoContainer]?
    
    // Weather details
    var weatherName:            String
    var weatherDescription:     String
    var weatherIconName:        String
    
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
    
    //Coding Keys
    private enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case cityName = "name"
        
        case weather = "weather"
        case main = "main"
        case wind = "wind"
        case clouds = "clouds"
    }
    
    private enum WeatherKeys: String, CodingKey{

        case weatherName = "main"
        case weatherDescription = "description"
        case weatherIconName = "icon"
    }

    private enum WeatherMainKeys: String, CodingKey{

        case temperature = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"

    }

    private enum WindKeys: String, CodingKey{
        case windSpeed = "speed"
        case windDeg = "deg"

    }

    private enum CloudKeys: String, CodingKey{
        case clouds = "all"
    }

    func encode(to encoder: Encoder) throws {
        
    }

    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.cityName = try container.decode(String.self, forKey: .cityName)
        
        let weatherInfoContainer = try container.decodeIfPresent([WeatherInfoContainer].self, forKey: .weather)
    
        self.weatherName = weatherInfoContainer?.first?.main ?? "Unknown"
        self.weatherDescription = weatherInfoContainer?.first?.description ?? "Unknown"
        self.weatherIconName = weatherInfoContainer?.first?.icon ?? "default_icon"
        
        let mainContainer = try container.nestedContainer(keyedBy: WeatherMainKeys.self, forKey: .main)

        self.temperature = try mainContainer.decode(Double.self, forKey: .temperature)
        self.pressure = try mainContainer.decode(Int.self, forKey: .pressure)
        self.humidity = try mainContainer.decode(Int.self, forKey: .humidity)
        self.minTemp = try mainContainer.decode(Double.self, forKey: .minTemp)
        self.maxTemp = try mainContainer.decode(Double.self, forKey: .maxTemp)

        let windContainer = try container.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)

        self.windSpeed = try windContainer.decode(Double.self, forKey: .windSpeed)
        self.windDeg = try windContainer.decode(Int.self, forKey: .windDeg)

        let cloudContainer = try container.nestedContainer(keyedBy: CloudKeys.self, forKey: .clouds)

        self.clouds = try cloudContainer.decode(Int.self, forKey: .clouds)

    }
}
