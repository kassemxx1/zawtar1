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
    let WEATHER_URL = "api.openweathermap.org/data/2.5/weather?lat=33.320815&lon=35.473069&appId=1db71a987db219ef67ae0d322b4a133e"
    let APP_ID = "1db71a987db219ef67ae0d322b4a133e"
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

     let Datamodule = WeatherDataModel()
    let params : [String : String] = ["lat" : "33.320815" , "lon" : "35.473069" ,"appId" : "1db71a987db219ef67ae0d322b4a133e"]
 

    override func viewDidLoad() {
        super.viewDidLoad()
        getweatherTemp()
        
        
        

    }
      //Write the getWeatherData method here:
    func getweatherTemp() {
    let session = URLSession.shared
    let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=33.320815&lon=35.473069&appId=1db71a987db219ef67ae0d322b4a133e")!
    let dataTask = session.dataTask(with: weatherURL) {
        (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            print("Error:\n\(error)")
        } else {
            if let data = data {
                let dataString = String(data: data, encoding: String.Encoding.utf8)
                print("All the weather data:\n\(dataString!)")
                if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                    if let mainDictionary = jsonObj!.value(forKey: "main") as? NSDictionary {
                    
                        if let temperature = mainDictionary.value(forKey: "temp") {
                           
                            DispatchQueue.main.async {
                               
                                
                                self.temperatureLabel.text = "\(temperature)"
                                self.cityLabel.text = "زوطر الشرقية"
                               
                            }
                        }
                    } else {
                        print("Error: unable to find temperature in dictionary")
                    }
                } else {
                    print("Error: unable to convert json data")
                }
            } else {
                print("Error: did not receive data")
            }
        }
    }
    dataTask.resume()
    }
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWeatherData() {
        cityLabel.text =  String( Datamodule.city)
        temperatureLabel.text = String(Datamodule.temperature)
        weatherIcon.image = UIImage(named : Datamodule.weatherIconName)
        
    }
    
    
    
    func updateWeatherData(json : JSON) {
        let TempResult = json["main"]["temp"].double
        Datamodule.temperature = Int(TempResult! - 273.15)
        Datamodule.city = json["name"].stringValue
        Datamodule.condition = json["weather"][0]["id"].intValue
        Datamodule.weatherIconName = Datamodule.updateWeatherIcon(condition: Datamodule.condition)
        
    }

    
    
}
