//
//  TripTableViewCell.swift
//  Packo
//
//  Created by Rodrigo Alves on 3/7/15.
//  Copyright (c) 2015 Rodrigo Alves. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        locationLabel.numberOfLines = 3
        locationLabel.lineBreakMode = .ByWordWrapping
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class func identifier() -> String {
        return "TripCell"
    }
}
