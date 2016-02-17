//
//  WeatherTableViewCell.swift
//  Packo
//
//  Created by Rodrigo Alves on 11/23/15.
//  Copyright © 2015 Kick Ass Apps. All rights reserved.
//
import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureScale: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let textColor = UIColor(rgba: "#2a6697")
        
        destinationLabel.textColor = textColor
        temperatureLabel.textColor = textColor
        
        durationLabel.textColor = UIColor(rgba: "#7c858d")
        
        weatherIcon.image = UIImage(named: "default")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func identifier() -> String {
        return "WeatherCell"
    }
    
}
