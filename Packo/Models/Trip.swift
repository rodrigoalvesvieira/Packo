//
//  Trip.swift
//  Packo
//
//  Created by Rodrigo Alves on 3/8/15.
//  Copyright (c) 2015 Rodrigo Alves. All rights reserved.
//

import CoreData

/**
 # Trip
 The object that represents the **Trip** entity in the app, of type `NSManagedObject`.
 */
class Trip: NSManagedObject {
    // The trip's unique ID
    @NSManaged var id: String!
    
    /// The trip's name
    @NSManaged var destination: String?
    
    /// The trip's start date.
    @NSManaged var startDate: NSDate?
    
    /// The trip's end date.
    @NSManaged var endDate: NSDate?
    
    // The trip's items
    @NSManaged var items: NSSet
    
    // Method for adding an item to the trip.
    @NSManaged func addItemsObject(item: Item)
    
    // An trip's name should be 2 chars long or more
    class var minDestinationLength: Int { return 2 }
    
    class func entityName() -> String {
        return "Trip"
    }
}