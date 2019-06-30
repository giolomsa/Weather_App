//
//  MainVCTableViewExtension.swift
//  Weather
//
//  Created by Gio Lomsa on 6/28/19.
//  Copyright © 2019 Giorgi Lomsadze. All rights reserved.
//

import Foundation
import UIKit

extension MainVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.weatherArrayWithoutCurrentCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = weatherTableView.dequeueReusableCell(withIdentifier: "WeatherDetailsCell") as? WeatherTableViewCell{
            
             let weather = self.viewModel.weatherArrayWithoutCurrentCity[indexPath.row]
            
                    DispatchQueue.global(qos: .background).async {
                        self.viewModel.getIcon(for: weather.weatherIconName, completion: { (image) in
                            DispatchQueue.main.async {
                                print(image)
                                cell.weatherIcon.image = image
                            }
                        })
                    }
                cell.cityNameLabel.text = weather.cityName
                cell.tamperatureLabel.text = weather.temperature.temperatureToString
                
                return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWeather = viewModel.weatherArrayWithoutCurrentCity[indexPath.row]
            self.selectedWeather = selectedWeather
            performSegue(withIdentifier: "WeatherDetailsSegue", sender: self)
        
    }
}


