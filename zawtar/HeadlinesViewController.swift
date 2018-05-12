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


class HeadlinesCell: UITableViewCell {
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    //@IBOutlet weak var details: UILabel!
//@IBOutlet weak var date: UILabel!
}
class HeadlinesViewController: UIViewController {
    
    @IBOutlet weak var headlinesTableView: UITableView!
    
    @IBOutlet weak var PageControl: UIPageControl!
    var pageNumber = 0
    var token: Int64?
    var newsList :[Item] = [Item]()
    

    let defaults = UserDefaults.standard
    var refreshControl = UIRefreshControl()
    
 
    override func viewDidLoad() {
        FirebaseApp.configure()
        super.viewDidLoad()
        
       
        
      retrieve()
        
        
        // Do any additional setup after loading the view, typically from a nib.
      
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        headlinesTableView.addSubview(refreshControl)
        
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
        return 150.0
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "headlineCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HeadlinesCell
        
        //        cell.layer.borderColor = UIColor.darkGray.cgColor
        //        cell.layer.borderWidth = 1.0
        //        cell.layer.cornerRadius = 10.0
        
        
        cell.title.text = newsList[indexPath.section].message.title
        cell.timeLabel.text = newsList[indexPath.section].message.time
        let storageRef = Storage.storage().reference()
        let storage = storageRef.child(newsList[indexPath.section].message.imagename)
        storage.getData(maxSize: 1*2024*2024) { (data, error) in
            if error == nil {
                
                if self.newsList[indexPath.section].done == true {
                    cell.previewImage.image = UIImage(data: data!)
                }
                
                
                }
                self.refreshControl.endRefreshing()
                
            }
     
        return cell
    }
    
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
        detailsViewController.newsTitle = newsList[indexPath.section].message.title
        detailsViewController.details = newsList[indexPath.section].message.details
        
    
        self.present(detailsViewController, animated: true)
        DispatchQueue.main.async(execute: {() -> Void in
         
   
        })
        
    }
    func retrieve() {
        
        SVProgressHUD.show()
        let messageDB = Database.database().reference()
        messageDB.observe(.childAdded, with: { snapshot in
            
            let snapshotvalue = snapshot.value as! Dictionary<String,String>
            let details = String(snapshotvalue["details"]!)
            let title = String(snapshotvalue["title"]!)
            let imagename = String(snapshotvalue["imagename"]!)
            let time = String(snapshotvalue["time"]!)
        
            let messages = Item()
            
            
            messages.message.details = details
            messages.message.title = title
            messages.message.imagename = imagename
            messages.message.time = time
            messages.done = true
            
            
            self.newsList.insert(messages, at: 0)
            
           
            SVProgressHUD.dismiss()
            self.headlinesTableView.reloadData()
    
        })
    
        
    }
    
     func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        return "\(day)-\(month)-\(year) \(hour):\(minutes)"
    }
    @objc func refresh(sender:AnyObject) {
        self.headlinesTableView.reloadData()
        
    }

 
    
}




