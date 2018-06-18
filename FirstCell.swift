//
//  FirstCell.swift
//  zawtar
//
//  Created by kassem on 5/22/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit
import Firebase
import CoreData
class FirstCell : UITableViewCell {

    
    @IBOutlet weak var SlideCollection: UICollectionView!

    var HeaderNews : [Header] = [Header]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var numberOfPics : Int = 0
    var numberOfVideos : Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        retrieve()
        SlideCollection.delegate = self
        SlideCollection.dataSource = self
        SlideCollection.reloadData()
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
        
        func scrollAutomatically(_ timer: Timer) {
            
        }
        
        
    }
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = SlideCollection {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < HeaderNews.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
        
    }
    func retrieve() {
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        db.collection("Header").order(by: "Document id")
        db.collection("Header").getDocuments()
            { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents  {
                        let message = Header(context: self.context)
                        let title = document.data()["title"] as? String
                        let details = document.data()["details"] as? String
                        let imagename = document.data()["imagename"] as? String
                        let time = document.data()["time"] as? String
                        let videos = document.data()["videos"] as? [String]
                        if videos?.count == nil {
                            self.numberOfVideos = 0
                        }
                        else {
                            self.numberOfVideos = (videos?.count)!
                        }
                        
                        let pics = document.data()["pics"] as? [String]
                        if pics?.count == nil {
                            self.numberOfPics = 0
                        }
                        else {
                            self.numberOfPics = (pics?.count)!
                        }
                        
                        message.details = details
                        message.title = title
                        message.imagename = imagename
                        message.time = time
                        message.pics = pics as NSObject?
                        message.numbOfPics = Int16(self.numberOfPics)
                        message.videos = videos as NSObject?
                        message.numbOfVideo = Int16(self.numberOfVideos)
                        
                        self.HeaderNews.insert(message, at: 0)
                        self.SlideCollection.reloadData()
                        
                        self.saveItems()
                        
                        
                        //                       self.refreshControl.endRefreshing()
                    }
                    
                }
                
        }
        
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
    
    
}
extension FirstCell : UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HedaerCollection", for: indexPath) as! HedaerCollection
        cell.HeaderDate.text = HeaderNews[indexPath.row].time
        cell.HeaderTitle.text = HeaderNews[indexPath.row].title
        if let image = HeaderNews[indexPath.row].imagename{
            
            
            cell.headerImage.loadImageUsingCacheWithUrlString(urlString: image )
        }
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HeaderNews.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
        
        detailsViewController.numb = Int(HeaderNews[indexPath.row].numbOfPics)
        detailsViewController.numbOfvideos = Int(HeaderNews[indexPath.row].numbOfVideo)
        detailsViewController.pics = HeaderNews[indexPath.row].pics as? [String]
        detailsViewController.picturesname = HeaderNews[indexPath.row].imagename
        detailsViewController.newsTitle = HeaderNews[indexPath.row].title
        detailsViewController.details = HeaderNews[indexPath.row].details
        detailsViewController.videos = HeaderNews[indexPath.row].videos as? [String]
        detailsViewController.date = HeaderNews[indexPath.row].time
        self.window?.rootViewController?.present(detailsViewController, animated: true)
    }

   

}

