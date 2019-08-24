//
//  APIClient.swift
//  Weather
//
//  Created by Gio Lomsa on 6/25/19.
//  Copyright © 2019 Giorgi Lomsadze. All rights reserved.
//

import Foundation

class APIClient{
    
    let httpLayer: HTTPLayer
    var defaultError: NSError = NSError(domain: "", code: 1, userInfo: nil)
    
    enum  cityId: String{
        case London = "2643743"
        case Tokyio = "1850147"
    }
    
    enum Result<Element>{
        case success(Element)
        case failure(NSError)
    }
    
    init(httpLayer: HTTPLayer){
        self.httpLayer = httpLayer
    }
    
    func getWeatherByCityId(city id: String, completion: @escaping (Result<Weather>)-> Void){
        
        self.httpLayer.request(at: .weatherByCityId(id), isIcon: false) { (data, response, error) in        
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode.isSuccessHTTPCode,
                let data = data
                else {
                    
                    if let error = error{
                        completion(.failure(error as NSError))
                    }
                    return
                }
            do{
                let decoder = JSONDecoder()
                let weather = try decoder.decode(Weather.self, from: data)
                completion(.success(weather))
            }catch let error{
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    func getWeatherByGeoLocation(latitude: Double, longitude: Double, completion: @escaping(Result<Weather>)-> Void){
        
        self.httpLayer.request(at: .weatherByGeographicCoordinates(latitude, longitude), isIcon: false) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode.isSuccessHTTPCode,
                let data = data
                else {
                    if let error = error{
                        completion(.failure(error as NSError))
                    }
                    return
            }
            do{
                let decoder = JSONDecoder()
                let weather = try decoder.decode(Weather.self, from: data)
                completion(.success(weather))
            }catch let error{
                print(error.localizedDescription)
            }
        }
    }
    
    func downloadIcon(for image: String , completion: @escaping(Result<Data>)-> Void){
        
        self.httpLayer.request(at: .weatherIcon(image), isIcon: true) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode.isSuccessHTTPCode,
                let imageData = data
                else {
                    if let error = error{
                        completion(.failure(error as NSError))
                    }
                    return
            }
            completion(.success(imageData))
        }
    }
    
}
