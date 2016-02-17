//
//  TemperatureScale.swift
//  Packo
//
//  Created by Rodrigo Alves on 12/28/15.
//  Copyright © 2015 Kick Ass Apps. All rights reserved.
//

import Foundation

enum TemperatureScale: String {
    case Celsius
    case Fahrenheit
    
    // MARK: Initializers
    init?(fullType: String) {
        guard let last = fullType.componentsSeparatedByString(".").last else { return nil }
        self.init(rawValue: last)
    }
    
    // MARK: Properties
    var type: String {
        return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
    }
}