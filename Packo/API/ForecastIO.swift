//
//  ForecastIO.swift
//  Packo
//
//  Created by Rodrigo Alves on 4/2/15.
//  Copyright (c) 2015 Rodrigo Alves. All rights reserved.
//

import Foundation

/// A small Swift wrapper for the Forecast.io API
class ForecastIO {
    let baseURL = "https://api.forecast.io/forecast/"
    
    // Your API Key for the Forecast.io API
    private var apiKey: String?
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    /// Takes a `String` representing a place and returns its encoded Forecast.io API url
    ///
    ///  - parameter   The: coordinates of the place to be fetched weather info from
    ///
    ///  - returns: The escaped Forecast.io API url
    private func buildRequestUrl(coordinates: String) -> String? {
        if let forecastIOAPIKey = self.apiKey {
            let requestUrl = "\(baseURL)\(forecastIOAPIKey)/\(coordinates)"
            
            return requestUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        }
        
        return nil
    }
    
    /// Takes a string representing geographical coordinates and returns
    /// its current weather data `CurrentWeather`.
    ///
    ///  - parameter coordinates:           the coordinates, lat and long, of the place. i.e. -30.0346471,-51.2176584"
    ///
    ///  - returns: a `CurrentWeather` object corresponding to the current weather in the given location.
    func getCurrentWeather(coordinates: String) -> Weather? {
        NSLog("Performing request for weather data. Coordinates are: \(coordinates)")
        
        if let rawRequestURL = buildRequestUrl(coordinates), forecastURL = NSURL(string: rawRequestURL) {
            NSLog("Forecast.IO API URL is \(forecastURL)")
            
            _ = NSURLSession.sharedSession()
            var weatherInfo: Weather?
            
            if let dataObject = NSData(contentsOfURL: forecastURL) {
                if let weatherDictionary = (try? NSJSONSerialization.JSONObjectWithData(dataObject, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary {
                    
                    weatherInfo = Weather(weatherDictionary: weatherDictionary)
                    
                    NSLog("Successfully fetched weather info")
                    print(weatherInfo)
                    
                    return weatherInfo
                }
            }
        }
        
        return nil
    }
}