//
//  Geocoder.swift
//  Packo
//
//  Created by Rodrigo Alves on 3/31/15.
//  Copyright (c) 2015 Rodrigo Alves. All rights reserved.
//

import Foundation

/// A class to represent geolocation data (lat/long coordinates) of any place on earth
class GeoLocation : NSObject {
    var locationName: String?
    // The latitude
    var latitude: String?
    // The longitude
    var longitude: String?
    
    override init() {
        self.latitude = ""
        self.longitude = ""
    }
    
    init(latitude: String, longitude: String) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init(locationName: String?, latitude: String?, longitude: String?) {
        self.init(latitude: latitude!, longitude: longitude!)
        self.locationName = locationName
    }
    
    override var description: String {
        return "\(self.latitude!),\(self.longitude!)"
    }
    
    func toString() -> String {
        return "\(self.latitude!),\(self.longitude!)"
    }
}


/// A small Swift wrapper for the Google Geocoding API
class Geocoder {
    let baseURL = "https://maps.googleapis.com/maps/api/geocode/json?address="
    
    // Your Google API Key for the Geocoding API
    private var apiKey: String?
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    /// Takes a `String` representing a place and returns its encoded Google Geocoding API url
    ///  - parameter location:           The location/place to be geocoded.
    ///
    ///  - returns: The escaped Google Geocoding API url
    private func buildRequestUrl(location: String?) -> String? {
        let requestUrl = "\(baseURL)\(location!)&key=\(apiKey!)"
        
        return requestUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
    
    /// Takes a dictionary representing the raw JSON data from the server, parses
    /// it and returns an array of `GeoLocation` objects.
    ///
    ///  - parameter resultsDictionary:           the raw JSON data
    ///
    ///  - returns: an array with all the geocoded places from the given dictionary
    func parseResults(results: NSDictionary) -> [GeoLocation] {
        var places: [GeoLocation] = []
        
        if let rawResults = results["results"] as? NSArray {
            for dictionary in rawResults {
                if let geometry = dictionary["geometry"] as? NSDictionary, let boundaries = geometry["location"] as? NSDictionary {
                    
                    let lat = boundaries["lat"] as? Double
                    let lng = boundaries["lng"] as? Double
                    
                    places.append(GeoLocation(latitude: "\(lat!)", longitude: "\(lng!)"))
                }
            }
        }
        
        return places
    }
    
    /// Takes a string representing a location and returns its geographical coordinates `GeoLocation`.
    ///
    ///  - parameter place:           the place to be geocoded
    ///
    ///  - returns: a `GeoLocation` object corresponding to the first occurrence in the Google Geocoding API.
    func geocode(place place: String?) -> GeoLocation? {
        let requestUrl = buildRequestUrl(place)
        
        let queryUrl = NSURL(string: requestUrl!)
        _ = NSURLSession.sharedSession()
        
        if let dataObject = NSData(contentsOfURL: queryUrl!) {
            let resultsDictionary = (try! NSJSONSerialization.JSONObjectWithData(dataObject, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
            let geoData = parseResults(resultsDictionary).first
            
            return GeoLocation(locationName: place, latitude: geoData?.latitude, longitude: geoData?.longitude)
        }
        
        return nil
    }
}