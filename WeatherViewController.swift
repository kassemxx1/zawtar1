//
//  WeatherViewController.swift
//  zawtar
//
//  Created by kassem on 5/10/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import Foundation

protocol changeCityDelegate {
    func UserEnteredANewCityNam(city : String)
}
class WeatherViewController: UIViewController , CLLocationManagerDelegate ,changeCityDelegate {
    
    
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?"
    let APP_ID = "1db71a987db219ef67ae0d322b4a133e"
    
    
    //TODO: Declare instance variables here
    let locationmanager = CLLocationManager()
    let Datamodule = WeatherDataModel()
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
        
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getweatherdata(url : String , parameter : [String :String]) {
        
        Alamofire.request(url + "/get" , parameters: parameter).responseJSON {
            response in
            if response.result.isSuccess {
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                self.updateUIWeatherData()
            }
            else {
                print("connection error")
                self.cityLabel.text =  "connection Issues"
            }
        }
    }
    
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    
    func updateWeatherData(json : JSON) {
        let TempResult = json["main"]["temp"].double
        Datamodule.temperature = Int(TempResult! - 273.15)
        Datamodule.city = json["name"].stringValue
        Datamodule.condition = json["weather"][0]["id"].intValue
        Datamodule.weatherIconName = Datamodule.updateWeatherIcon(condition: Datamodule.condition)
        
    }
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWeatherData() {
        cityLabel.text =  String( Datamodule.city)
        temperatureLabel.text = String(Datamodule.temperature)
        weatherIcon.image = UIImage(named : Datamodule.weatherIconName)
        
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if (location.horizontalAccuracy > 0) {
            locationmanager.stopUpdatingLocation()
            locationmanager.delegate = nil
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params : [String : String] = ["lat" : latitude , "lon" : longitude ,"appId" :APP_ID]
            getweatherdata(url: WEATHER_URL, parameter: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavailabale"
    }
    
    
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func UserEnteredANewCityNam(city: String) {
        let params : [String : String] = ["q" : city , "appId" : APP_ID]
        getweatherdata(url: WEATHER_URL, parameter: params)
        
    }
    
    
    //Write the PrepareForSegue Method here
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
    
    
}
