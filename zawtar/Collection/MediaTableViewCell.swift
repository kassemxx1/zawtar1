//
//  MediaTableViewCell.swift
//  zawtar
//
//  Created by kassem on 6/10/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var CompanyName: UILabel!
    
    @IBOutlet weak var Collection: UICollectionView!
    
    var pics : [String] = [String]()
    override func awakeFromNib() {
        super.awakeFromNib()
        Collection.delegate = self
        Collection.dataSource = self
      Collection.reloadData()
    }
    
}

extension MediaTableViewCell : UICollectionViewDataSource,UICollectionViewDelegate {

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        cell.images.loadImageUsingCacheWithUrlString(urlString: pics[indexPath.row])
    
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pics.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ImageViewController = mainStoryboard.instantiateViewController(withIdentifier: "imageViewController") as! imageViewController
       ImageViewController.bigimagename = pics[indexPath.row]
        self.window?.rootViewController?.present(ImageViewController, animated: true)
    }

    
    
    
}

