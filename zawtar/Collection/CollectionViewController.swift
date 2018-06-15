//
//  CollectionViewController.swift
//  zawtar
//
//  Created by kassem on 6/10/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import CoreData

class CollectionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var MediaTableView: UITableView!
    var array = [UIImage(named: "fog"),UIImage(named: "cloudy2"),UIImage(named: "dunno"),UIImage(named: "tstorm1"),UIImage(named: "tstorm3"),UIImage(named: "snow4"),UIImage(named: "light_rain"),UIImage(named: "fog")]
    var newsList : [Promotion] = [Promotion]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var numberOfPics : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        MediaTableView.delegate = self
        MediaTableView.dataSource = self
        retrieve()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return newsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTableViewCell") as! MediaTableViewCell
        cell.pics = newsList[indexPath.row].pics as! [String]
//        let numb = String(int_fast64_t(newsList[indexPath.row].phoneNumber))
//        cell.numberLabel.text = "هاتف : \(numb)"
        cell.CompanyName.text = newsList[indexPath.row].name

        return cell
    }
    func retrieve() {
        SVProgressHUD.show()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        db.collection("Promotion").order(by: "Document id")
        db.collection("Promotion").getDocuments()
            { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents  {
                        let promotion = Promotion(context: self.context)
                        let phoneNumber = document.data()["phoneNumber"] as? Double
                        let name = document.data()["name"] as? String
                        let pics = document.data()["pics"] as? [String]
                        if pics?.count == nil {
                            self.numberOfPics = 0
                        }
                        else {
                            self.numberOfPics = (pics?.count)!
                        }
                        promotion.name = name
                        promotion.phoneNumber = phoneNumber!
                        promotion.pics = pics as NSObject?
                        promotion.numberOfPics = Int16(self.numberOfPics)
                        self.newsList.insert(promotion, at: 0)
                        self.MediaTableView.reloadData()
                        self.saveItems()
                        SVProgressHUD.dismiss()
                        
                        //                       self.refreshControl.endRefreshing()
                    }
                    
                }
                
        }
        
    }
    func saveItems()  {
        
        do {
            
            try context.save()
        }
        catch {
            print("error save")
        }
    }
}

