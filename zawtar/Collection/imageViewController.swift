//
//  imageViewController.swift
//  zawtar
//
//  Created by kassem on 6/18/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit

class imageViewController: UIViewController {
    var bigimagename :String?
    @IBOutlet weak var BigImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BigImage.loadImageUsingCacheWithUrlString(urlString: bigimagename!)

        // Do any additional setup after loading the view.
    }


    @IBAction func DoneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
