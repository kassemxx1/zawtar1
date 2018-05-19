//
//  ViewController.swift
//  zawtar
//
//  Created by kassem on 4/30/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import CoreLocation
import Alamofire
import SwiftyJSON
import Foundation
import CoreData
class HeadlinesCell: UITableViewCell{
    @IBOutlet weak var previewImage: UIImageView!
 
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    //@IBOutlet weak var details: UILabel!
//@IBOutlet weak var date: UILabel!
}
class HeadlinesViewController: UIViewController , CLLocationManagerDelegate  {
    @IBOutlet weak var ViewConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var SlideView: UIView!
    
    @IBAction func AkhbarButton(_ sender: Any) {
    }
    @IBAction func AcrchiveButton(_ sender: Any) {
    }
    
    
    @IBOutlet weak var headlinesTableView: UITableView!
    @IBOutlet weak var PageControl: UIPageControl!
    var pageNumber = 0
    var token: Int64?
    var newsList :[Message] = [Message]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var refreshControl = UIRefreshControl()
   // let Filepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?"
    let APP_ID = "1db71a987db219ef67ae0d322b4a133e"
    //TODO: Declare instance variables here
    let locationmanager = CLLocationManager()
    let Datamodule = WeatherDataModel()
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
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
        temperatureLabel.text = String(Datamodule.temperature) + "°"
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
    override func viewDidLoad() {
        //TODO:Set up the location manager here.
    
        blurView.layer.cornerRadius = 15
        SlideView.layer.shadowColor = UIColor.black.cgColor
        SlideView.layer.shadowOpacity = 1
        SlideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        ViewConstrain.constant = -145
        
        
        
        
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
        
        super.viewDidLoad()
        retrieve()
       
        // Do any additional setup after loading the view, typically from a nib.
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        headlinesTableView.addSubview(refreshControl)
}
    
    @IBAction func panPerfomed(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in : self.view).x
            if translation > 0 {
                if ViewConstrain.constant < 20 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.ViewConstrain.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }else {
                if ViewConstrain.constant > -150  {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.ViewConstrain.constant += translation / 10
                        self.view.layoutIfNeeded()
            })
                }
            
        }
            
        }else if sender.state == .ended{
            if ViewConstrain.constant < -10 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.ViewConstrain.constant = -145
                    self.view.layoutIfNeeded()
                })
            }else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.ViewConstrain.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
        }
 
    }
    
}

/////////////////////////////////////////////////////////////////////////////////
extension HeadlinesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame:CGRect (x: 0, y: 0, width: 320, height: 1) ) as UIView
        view.backgroundColor = UIColor.lightGray
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == newsList.count - 1, let _ = self.token {
            //last cell
            self.pageNumber += 1
            
        }
    }
    //MARK:CellforRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "headlineCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HeadlinesCell
        if indexPath.row == 0 {
            
        }
        cell.previewImage.setRounded()
        cell.title.text = newsList[indexPath.section].title
        cell.timeLabel.text = newsList[indexPath.section].time
        
        if let image = newsList[indexPath.section].imagename{
            
        
            cell.previewImage.loadImageUsingCacheWithUrlString(urlString: image )
        }
//        let storageRef = Storage.storage().reference()
//
//        let storage = storageRef.child(newsList[indexPath.section].imagename!)
//
//        storage.getData(maxSize: 1*2024*2024) { (data, error) in
//
//            if  error == nil {
//
//                       cell.previewImage.image = UIImage(data: data!)
//                }
//
//            }
      //  refreshControl.endRefreshing()
        return cell
    }
    // MARK:didselectedRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if newsList[indexPath.section].done == false {
            newsList[indexPath.section].done = true
        }
        else {
            newsList[indexPath.section].done = false
        }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
        let cell = tableView.cellForRow(at: indexPath) as! HeadlinesCell
        detailsViewController.previewImage = cell.previewImage.image
        detailsViewController.newsTitle = newsList[indexPath.section].title
        detailsViewController.details = newsList[indexPath.section].details
        self.present(detailsViewController, animated: true)
        
    }
    // MARK:Retrive()
 /*   func retrieve() {
        
        SVProgressHUD.show()
        let messageDB = Database.database().reference()
        messageDB.observe(.childAdded, with: { snapshot in
            let snapshotvalue = snapshot.value as! Dictionary<String,String>
            let details = String(snapshotvalue["details"]!)
            let title = String(snapshotvalue["title"]!)
            let imagename = String(snapshotvalue["imagename"]!)
            let time = String(snapshotvalue["time"]!)
            print(details)
            print(title)
            let messages = Message(context: self.context)
            messages.details = details
            messages.title = title
            messages.imagename = imagename
            messages.time = time
            messages.done = true
            
            self.newsList.insert(messages, at: 0)
            self.saveItems()
            SVProgressHUD.dismiss()
            self.headlinesTableView.reloadData()
        })
    }*/
    func retrieve() {
        SVProgressHUD.show()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        db.collection("news").getDocuments()
            { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents  {
                        let message = Message(context: self.context)
                        let title = document.data()["title"] as? String
                        let details = document.data()["details"] as? String
                        let imagename = document.data()["imagename"] as? String
                        let time = document.data()["time"] as? String
                        message.details = details
                        message.title = title
                        message.imagename = imagename
                        message.time = time
                        self.newsList.insert(message, at: 0)
                        
                       self.headlinesTableView.reloadData()
                        self.saveItems()
                        SVProgressHUD.dismiss()
                      
                       self.refreshControl.endRefreshing()
                    }
                }
                
        }
    }
    //Refresh
    @objc func refresh(sender:AnyObject) {
        newsList.removeAll()
        retrieve()
 
    }
    //saveItem
    func saveItems()  {
      
        do {
           
            try context.save()
        }
        catch {
            print("error save")
        }
    }
    //LoadItem
  func loadItems() {
    
        let request : NSFetchRequest<Message> = Message.fetchRequest()
        do {
           newsList =  try context.fetch(request)
        }catch {
            print("error load")
        }
    
    }

}

    



