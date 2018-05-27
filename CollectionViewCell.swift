//
//  CollectionViewCell.swift
//  zawtar
//
//  Created by kassem on 5/26/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var Image : UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
