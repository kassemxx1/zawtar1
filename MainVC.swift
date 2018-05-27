//
//  MainVC.swift
//  zawtar
//
//  Created by kassem on 5/26/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UITableViewController {
    var imageArray : [ImageOfImage] = [ImageOfImage]()
    let kassem = ["zawtar","z3","sunny"]


    override func viewDidLoad() {
        super.viewDidLoad()
      //  retrieve()
        
      
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewCell", for: indexPath) as! TableViewCell
        return cell
    }


    func retrieve() {
      
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        db.collection("news").order(by: "Document id")
        db.collection("news").getDocuments()
            { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents  {
                        
                        let imagename = document.data()["imagename"] as? String
                        let image = ImageOfImage()
                        image.imageName = imagename
                        self.imageArray.insert(image, at: 0)
                        
                        self.tableView.reloadData()
                        
                        
                        //                       self.refreshControl.endRefreshing()
                    }
                    
                }
                
        }
        
    }
}
extension MainVC : UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        
        let name = kassem[indexPath.row]
            
        cell.Image.image = UIImage(named: name)
        
        
        return cell
       
    }


}
