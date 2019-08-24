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
    @IBOutlet weak var metricsButton: UIButton!
    
    // Current City View
    @IBOutlet weak var currentCityTempLabel:            UILabel!
    @IBOutlet weak var currentCityNameLabel:            UILabel!
    @IBOutlet weak var currentCityWeatherNameLabel:     UILabel!
    @IBOutlet weak var currentCityWeatherIconImageView: UIImageView!
    
    // MARK:- ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Add Observer
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrentLocationWeather), name: MainViewModel.currentLocationweatherChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateWeatherTableView), name: MainViewModel.weatherArrayChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrentWeatherFromViewModel), name: CoreLocationManager.locationManagerAuthorizarionStatus, object: nil)
        
        //
        custumizeUI()
        updateActivityIndicator(on: true)
        
        // Manage delegate, dataSource
        weatherTableView.dataSource     = self
        weatherTableView.delegate       = self
        self.viewModel.getWeatherFromServer()
    }        
    
    // MARK:- IBActions
    @IBAction func currentCityDetailesButtonTapped(_ sender: UIButton){
        if let selectedWeather = viewModel.currentCityWeather{
            self.selectedWeather = selectedWeather
            performSegue(withIdentifier: "WeatherDetailsSegue", sender: self)
        }else{
            // Show Error alert
        }
    }
    
    @IBAction func addCityButtonTapped(_ sender: UIButton) {
        if let addCityVC = storyboard?.instantiateViewController(withIdentifier: "AddCityVC"){
            navigationController?.present(addCityVC, animated: true, completion: nil)
        }
        
    }
    @IBAction func metricButtonTapped(_ sender: UIButton) {
        
    }
    

    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WeatherDetailsVC{
            destination.selectedWeather = self.selectedWeather
        }
    }
    
    // MARK:- Class Methods
    
    private func custumizeUI(){
        self.activityIndicatorBackground.layer.cornerRadius     = self.activityIndicatorBackground.frame.width/4
        self.currentCityBlackBgView.layer.cornerRadius          = 15
        metricsButton.layer.cornerRadius                        = 15
        metricsButton.layer.borderColor                         = UIColor.white.cgColor
//        var metricButtontitle = NSAttributedString(attributedString: "C/F")
        
        let celsiusString = "C"
        let farengString = "F"
        let myAttribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15) ]
        let celsiusAttributedString = NSAttributedString(string: celsiusString, attributes: myAttribute)
        
        let farengAttributedString = NSAttributedString(string: celsiusString, attributes: myAttribute)
        
        // set attributed text on a UILabel
        let buttonTitle = "\(celsiusAttributedString)  \(farengString)"
        metricsButton.setAttributedTitle(celsiusAttributedString, for: .normal)

    }
    
    @objc func updateCurrentWeatherFromViewModel(){
        viewModel.getWeatherByGeoLocation()
    }
    
    @objc private func updateCurrentLocationWeather(){
        DispatchQueue.main.async {
            self.updateCurrentCityView()
//            self.weatherTableView.reloadData()
            

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
    
    // Manage activity Indicator
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
    
    private func changeMetricsUI(){
        
    }
    
   @objc private func updateWeatherTableView(){
        DispatchQueue.main.async {
            self.weatherTableView.reloadData()
        }
    }
    
}

