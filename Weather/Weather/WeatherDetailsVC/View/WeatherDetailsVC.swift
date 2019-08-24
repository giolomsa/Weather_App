//
//  WeatherDetailsVC.swift
//  Weather
//
//  Created by Gio Lomsa on 6/29/19.
//  Copyright © 2019 Giorgi Lomsadze. All rights reserved.
//

import UIKit

class WeatherDetailsVC: UIViewController {

    var selectedWeather: Weather?
    let viewModel = MainViewModel()
    //
    @IBOutlet weak var activityIndicatorBackgroundView: UIView!
    @IBOutlet weak var activityIndicator:               UIActivityIndicatorView!
    @IBOutlet weak var selectedWeatherBGView:           UIView!
    // Weather Details Components
    @IBOutlet weak var selectedWeatherIconImageView:    UIImageView!
    @IBOutlet weak var selectedWeatherTemperatureLabel: UILabel!
    @IBOutlet weak var selectedWeatherCityNameLabel:    UILabel!
    @IBOutlet weak var selectedWeatherWeatherNameLabel: UILabel!
    // Wind/Cloud Details Components
    @IBOutlet weak var windDetailsBgView:               UIView!
    @IBOutlet weak var windSpeedLabel:                  UILabel!
    @IBOutlet weak var windDegreeLabel:                 UILabel!
    @IBOutlet weak var cloudsAllLabel:                  UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(navigateBacktoMainScreen))
        swipeLeftGesture.direction = .right
        view.addGestureRecognizer(swipeLeftGesture)
        
        activityIndicator.startAnimating()
        
        updateUI()
        custumizeUI()
//        print(selectedWeather)
        // Do any additional setup after loading the view.
    }
    
    
    private func updateUI(){
        if let weather = selectedWeather{
            self.selectedWeatherCityNameLabel.text          = weather.cityName
            self.selectedWeatherTemperatureLabel.text       = weather.temperature.temperatureToString
            self.selectedWeatherWeatherNameLabel.text       = weather.weatherName
            self.windSpeedLabel.text                        = weather.windSpeed.weatherSpeedToString
            self.windDegreeLabel.text                       = weather.windDeg.degreeToString
            self.cloudsAllLabel.text                        = String(weather.clouds)
            
            DispatchQueue.global(qos: .background).async {
                self.viewModel.getIcon(for: weather.weatherIconName, completion: {[weak self] (image) in
                    DispatchQueue.main.async {
                        self?.selectedWeatherIconImageView.image = image
                    }
                })
            }
            activityIndicator.startAnimating()
            activityIndicatorBackgroundView.isHidden        = true
        }
        
    }
    
    private func custumizeUI(){
        self.selectedWeatherBGView.layer.cornerRadius   = 15
        self.windDetailsBgView.layer.cornerRadius       = 15
    }
    
    @objc func navigateBacktoMainScreen(){       
       print("navigate")
        dismiss(animated: true, completion: nil)
    }
}
