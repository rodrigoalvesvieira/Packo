//
//  ItemTableViewCell.swift
//  Packo
//
//  Created by Rodrigo Alves on 11/23/15.
//  Copyright © 2015 Kick Ass Apps. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    // Override methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class func identifier() -> String {
        return "ItemCell"
    }
}
