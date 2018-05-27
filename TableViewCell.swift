//
//  TableViewCell.swift
//  zawtar
//
//  Created by kassem on 5/26/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var CollectionVIew: UICollectionView!


 
    
}
extension TableViewCell {
    
    func setCollectionViewDataSourceDelegate <D: UICollectionViewDelegate & UICollectionViewDataSource>
        (_ dataSourceDelegate : D,forRow row: Int)
    {
       CollectionVIew.delegate = dataSourceDelegate
        CollectionVIew.dataSource = dataSourceDelegate
        CollectionVIew.reloadData()
}

}
