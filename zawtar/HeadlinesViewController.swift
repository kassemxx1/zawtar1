//
//  ViewController.swift
//  zawtar
//
//  Created by kassem on 4/30/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit
import Firebase


class HeadlinesCell: UITableViewCell {
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var title: UILabel!
//@IBOutlet weak var details: UILabel!
//@IBOutlet weak var date: UILabel!
}
class HeadlinesViewController: UIViewController {
    
    @IBOutlet weak var headlinesTableView: UITableView!
    
    
    var pageNumber = 0
    var token: Int64?
    var newsList :[Message] = [Message]()
 
    override func viewDidLoad() {
        FirebaseApp.configure()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      retrieve()
    
        
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
        return 100.0
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
        
        cell.title.text = newsList[indexPath.section].title
        
        let storageRef = Storage.storage().reference()
        let storage = storageRef.child(newsList[indexPath.section].imagename)
        storage.getData(maxSize: 1*2024*2024) { (data, error) in
            if error == nil {
                cell.previewImage.image = UIImage(data : data!)
                
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
        let cell = tableView.cellForRow(at: indexPath) as! HeadlinesCell
        detailsViewController.previewImage = cell.previewImage.image
        detailsViewController.newsTitle = newsList[indexPath.section].title
        detailsViewController.details = newsList[indexPath.section].details
    
        self.present(detailsViewController, animated: true)
  
        
    }
    func retrieve() {
        let messageDB = Database.database().reference()
        messageDB.observe(.childAdded, with: { snapshot in
            
            let snapshotvalue = snapshot.value as! Dictionary<String,String>
            let details = snapshotvalue["details"]!
            let title = snapshotvalue["title"]!
            let imagename = snapshotvalue["imagename"]!
            
            let messages = Message()
            
            messages.details = String(details)
            messages.title = String(title)
            messages.imagename = String(imagename)
        
            
            self.newsList.append(messages)
            
            
            self.headlinesTableView.reloadData()
            
        })
        
        
        
        
    }
    

    
}




