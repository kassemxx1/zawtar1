//
//  File.swift
//  zawtar
//
//  Created by kassem on 5/11/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import Foundation
import UIKit

class NavigationCell: UITableViewCell {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var countContainer: UIView!
    
    override func awakeFromNib() {
        
        titleLabel.font = UIFont(name: "Avenir-Black", size: 16)
        titleLabel.textColor = UIColor.white
        
        countLabel.font = UIFont(name: "Avenir-Black", size: 13)
        countLabel.textColor = UIColor.white
        
        countContainer.backgroundColor = UIColor(red: 0.33, green: 0.62, blue: 0.94, alpha: 1.0)
        countContainer.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        let countNotAvailable = countLabel.text == nil
        
        countContainer.isHidden = countNotAvailable
        countLabel.isHidden = countNotAvailable
        
    }
}

