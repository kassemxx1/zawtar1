//
//  DetailsViewController.swift
//  zawtar
//
//  Created by kassem on 4/30/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var detailsLabel: UITextView!
    var previewImage: UIImage?
    var newsTitle: String?
    var details: String?
    var section: String?
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        // Do any additional setup after loading the view.
        fillNewsData()
    }
    
    
    private func fillNewsData() {
        previewImageView.image = previewImage
        titleLabel.text = newsTitle
        detailsLabel.text = details
    }

    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
