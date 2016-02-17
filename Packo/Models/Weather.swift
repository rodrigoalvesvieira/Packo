//
//  Weather.swift
//  Packo
//
//  Created by Rodrigo Alves on 3/30/15.
//  Copyright (c) 2015 Rodrigo Alves. All rights reserved.
//

import Foundation
import UIKit

struct Weather {
    var currentTime: String
    var temperature: Double
    var humidity: Double
    var precipProbability: Double
    var summary: String
    var iconString: String
    
    init(weatherDictionary: NSDictionary) {
        let weather = weatherDictionary["currently"] as! NSDictionary
        
        self.temperature = weather["temperature"] as! Double
        self.humidity = weather["humidity"] as! Double
        self.precipProbability = weather["precipProbability"] as! Double
        self.summary = weather["summary"] as! String
        self.iconString = weather["icon"] as! String
        
        let currentTimeIntValue = weather["time"] as! Int
        self.currentTime = Weather.dateStringFromUnixtime(currentTimeIntValue)
    }
    
    static func dateStringFromUnixtime(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func toCelsius() -> Int {
        let celsius = 5.0 / 9.0 * (self.temperature - 32.0)
        let celsiusFloor = Int(floor(celsius))
        
        if (celsius - 0.5) > Double(celsiusFloor) {
            return celsiusFloor + 1
        }
        
        return celsiusFloor
    }
}