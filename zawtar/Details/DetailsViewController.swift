//
//  DetailsViewController.swift
//  zawtar
//
//  Created by kassem on 4/30/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
class DetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    

    
    
    
    @IBOutlet weak var detailsTable: UITableView!
    
    
//
//    @IBOutlet weak var previewImageView: UIImageView!
//
//    @IBOutlet weak var titleLabel: UILabel!
//
//    @IBOutlet weak var detailsLabel: UITextView!
//    var previewImage: UIImage?
    var newsTitle: String?
    var details: String?
    var picturesname : UIImage?
    var pics:[String]?
//    var section: String?
//    var date: String?
//
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTable.delegate = self
        detailsTable.dataSource = self

        // Do any additional setup after loading the view.
      //  fillNewsData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pics?.count == 0 {
            return 2
        }
        else {
            return 2 + (pics?.count)!
        }
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        }
        else if indexPath.row == 1 {
            return UITableViewAutomaticDimension
        }
        else {
            return 200
        }
    }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell") as! TitleCell
                cell.titlecel.text = newsTitle
                return cell
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailCell
                cell.detailCell.text = details
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "pictureCell", for: indexPath) as! PicturesCell
                let image = pics![indexPath.row - 2]
                    
                    cell.picturesCell.loadImageUsingCacheWithUrlString(urlString: image )
                    
                
                return cell
            }
        }
 
    

//    private func fillNewsData() {
//        previewImageView.image = previewImage
//        titleLabel.text = newsTitle
//        detailsLabel.text = details
//    }

    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

