//
//  Item.swift
//  Packo
//
//  Created by Rodrigo Alves on 3/3/15.
//  Copyright (c) 2015 Rodrigo Alves. All rights reserved.
//

import CoreData

/// The object that represents the **Item** entity in the app, of type `NSManagedObject`.
class Item: NSManagedObject {
    
    // The item's unique ID
    @NSManaged var id: String!
    
    /// The item's name.
    @NSManaged var name: String!
    
    /// The item's picture in bytes.
    @NSManaged var picture: NSData!
    
    /// The item's addition date.
    @NSManaged var addedDate: NSDate!
    
    /// The item's done date.
    @NSManaged var doneDate: NSDate!
    
    /// The trip to which the item belongs
    @NSManaged var trip: Trip!
    
    // An item's name should be 2 chars long or more
    class var minNameLength: Int { return 2 }
    
    class func entityName() -> String {
        return "Item"
    }
}
