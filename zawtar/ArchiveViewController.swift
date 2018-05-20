//
//  ArchiveViewController.swift
//  zawtar
//
//  Created by kassem on 5/15/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit
import WebKit
import CoreData
import Firebase
import SVProgressHUD
class ArchiveViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var videTableView: UITableView!
    var VideoArray :[VideoContent] = [VideoContent]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
      
        retrieve()
        videTableView.delegate = self
        videTableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        videTableView.addSubview(refreshControl)
       
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VideoArray.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellidentifier = "customcell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifier) as! CustomCell
        let code = VideoArray[indexPath.row].videoCode
        let title = VideoArray[indexPath.row].videoTitle
        let url = URL(string: code!)
        cell.video.loadRequest(URLRequest(url: url!))
        cell.VideoTitle.text = title
         self.refreshControl.endRefreshing()
        return cell
    }
 /*   func retreive() {
        let messageDB = Database.database().reference()
        messageDB.observe(.childAdded, with: { snapshot in
            let snapshotvalue = snapshot.value as! Dictionary<String,String>
            let videoCode = String(snapshotvalue["videoCode"]!)
            let videoTitle = String(snapshotvalue["videoTitle"]!)
            let video = VideoContent()
            video.videoCode = videoCode
            video.videoTitle = videoTitle
            self.VideoArray.insert(video, at: 0)
            self.videTableView.reloadData()
    })
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func saveItems()  {
        
        do    {
            
            try context.save()
        }
        catch {
            print("error save")
        }
    }
    //LoadItem
    func loadItems() {
        
        let request : NSFetchRequest<VideoContent> = VideoContent.fetchRequest()
        do {
            VideoArray =  try context.fetch(request)
        }catch {
            print("error load")
        }
        
    }
    func retrieve() {
        SVProgressHUD.show()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        db.collection("video").getDocuments()
            { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents  {
                let new = VideoContent(context: self.context)
                    let Code = document.data()["videoCode"] as? String
                    let youtubeLink = "https://www.youtube.com/embed/"
                    let videoCode = youtubeLink + Code!
                    new.videoCode = videoCode
                    new.videoTitle = document.data()["videoTitle"] as? String
                    self.VideoArray.insert(new, at: 0)
                    print(self.VideoArray)
                    self.saveItems()
                    SVProgressHUD.dismiss()
                    self.videTableView.reloadData()
                }
            }
            
        }
    }
    @objc func refresh(sender:AnyObject) {
        self.videTableView.reloadData()
    }
}
