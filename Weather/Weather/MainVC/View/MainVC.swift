//
//  ViewController.swift
//  Weather
//
//  Created by Gio Lomsa on 6/25/19.
//  Copyright © 2019 Giorgi Lomsadze. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    //
    let viewModel = MainViewModel()
    var selectedWeather: Weather?
    
    // MARK:- IBOutlets
    @IBOutlet weak var activityIndiator:                UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorBackground:     UIView!
    @IBOutlet weak var currentCityBlackBgView:          UIView!
    @IBOutlet weak var currentCityDetailesButton:       UIButton!
    @IBOutlet weak var weatherTableView:                UITableView!
    // Current City View
    @IBOutlet weak var currentCityTempLabel:            UILabel!
    @IBOutlet weak var currentCityNameLabel:            UILabel!
    @IBOutlet weak var currentCityWeatherNameLabel:     UILabel!
    @IBOutlet weak var currentCityWeatherIconImageView: UIImageView!
    
    // MARK:- ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        custumizeUI()
        updateActivityIndicator(on: true)
        // Add Observer
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrentLocationWeather), name: MainViewModel.currentLocationweatherChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateWeatherTableView), name: MainViewModel.weatherArrayChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrentWeatherInViewModel), name: CoreLocationManager.locationManagerAuthorizarionStatus, object: nil)
        
        // Manage delegate, dataSource
        weatherTableView.dataSource     = self
        weatherTableView.delegate       = self
        self.viewModel.getWeatherFromServer()
    }        
    
    // MARK:- IBActions
    
    @IBAction func currentCityDetailesButtonTapped(_ sender: UIButton){
        self.selectedWeather = viewModel.currentCityWeather
        performSegue(withIdentifier: "WeatherDetailsSegue", sender: self)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WeatherDetailsVC{
            destination.selectedWeather = self.selectedWeather
        }
    }
    
    // MARK:- Class Methods
    
    private func custumizeUI(){
        self.activityIndicatorBackground.layer.cornerRadius     = self.activityIndicatorBackground.frame.width/4
        self.currentCityBlackBgView.layer.cornerRadius          = 15
    }
    
    @objc func updateCurrentWeatherInViewModel(){
        viewModel.getWeatherByGeoLocation()
    }
    
    @objc private func updateCurrentLocationWeather(){
        DispatchQueue.main.async {
            self.updateCurrentCityView()
            self.weatherTableView.reloadData()
            

        }
    }
    
    private func updateCurrentCityView(){
        if let currentCityWeather = viewModel.currentCityWeather{
            self.currentCityNameLabel.text          = currentCityWeather.cityName
            self.currentCityTempLabel.text          = currentCityWeather.temperature.temperatureToString
            self.currentCityWeatherNameLabel.text   = currentCityWeather.weatherName
            
            DispatchQueue.global(qos: .background).async {
                self.viewModel.getIcon(for: currentCityWeather.weatherIconName) { (image) in
                    DispatchQueue.main.async {
                        self.currentCityWeatherIconImageView.image = image
                    }
                }
            }
            // hide activityindicator
            updateActivityIndicator(on: false)
        }
    }
    
    private func updateActivityIndicator(on: Bool){
        if on{
            self.activityIndiator.startAnimating()
            self.activityIndiator.isHidden                          = false
            self.activityIndicatorBackground.isHidden               = false
        }else{
            self.activityIndiator.stopAnimating()
            self.activityIndiator.isHidden                          = true
            self.activityIndicatorBackground.isHidden               = true
        }
    }
    
   @objc private func updateWeatherTableView(){
    print("From Observer")
    DispatchQueue.main.async {
        self.weatherTableView.reloadData()
    }
    }
}

