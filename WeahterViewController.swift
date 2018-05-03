//
//  WeahterViewController.swift
//  zawtar
//
//  Created by kassem on 5/2/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import Foundation

class WeahterViewController: UIViewController {
    let WEATHER_URL = "api.openweathermap.org/data/2.5/weather?lat=33.320815&lon=35.473069&APPID=1db71a987db219ef67ae0d322b4a133e"
    let APP_ID = "1db71a987db219ef67ae0d322b4a133e"
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

     let Datamodule = WeatherDataModel()
    let params : [String : String] = ["lat" : "33.320815" , "lon" : "35.473069" ,"appId" : "1db71a987db219ef67ae0d322b4a133e"]
 

    override func viewDidLoad() {
        super.viewDidLoad()
        getweatherdata(url: WEATHER_URL)
        
        

    }
      //Write the getWeatherData method here:
    func getweatherdata(url : String ) {
        
        Alamofire.request(url).responseJSON {
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
    
    
    
    
    
    
    
    
}
