//
//  TripsViewController.swift
//  Packo
//
//  Created by Rodrigo Alves on 9/18/15.
//  Copyright © 2015 Kick Ass Apps. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel

class TripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var trips: [Trip] = []
    var deleteTripIndexPath: NSIndexPath? = nil
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let tripsFetchRequest = NSFetchRequest(entityName: "Trip")
        let primarySortDescriptor = NSSortDescriptor(key: "destination", ascending: true)
        
        tripsFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        var appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        
        let frc = NSFetchedResultsController(
            fetchRequest: tripsFetchRequest,
            managedObjectContext: appDel!.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        frc.delegate = self
        return frc
    }()
    
    // MARK: - Constants
    var mixpanel: Mixpanel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let mixpanel = Mixpanel.sharedInstance() {
//            mixpanel.track("View Opened", properties: ["Trips View": NSDate()])
//        }
        
        do {
            try fetchedResultsController.performFetch()
            self.trips = (fetchedResultsController.fetchedObjects as? [Trip])!
            
            if self.trips.count == 0 {
                tableView.hidden = true
            }
        } catch {
            NSLog("An error occurred: could not fetch Trip")
        }
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - UITableViewDataSource delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let trip = trips[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tripCell") as! TripTableViewCell
        
        let outputDateFormatter = NSDateFormatter()
        outputDateFormatter.dateFormat = "MMM dd"
        
        if let startDate = trip.startDate {
            let startDateStr = outputDateFormatter.stringFromDate(startDate)
            cell.durationLabel.text = startDateStr
        }
        
        if let endDate = trip.endDate {
            let endDateStr = outputDateFormatter.stringFromDate(endDate)
            
            if let durationLabelText = cell.durationLabel.text {
                cell.durationLabel.text = durationLabelText + " - " + endDateStr
            }
        }
        
        cell.locationLabel.text = trip.destination
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            deleteTripIndexPath = indexPath
            let tripToDelete = trips[indexPath.row]
            confirmDelete(tripToDelete)
        }
    }
    
    func confirmDelete(trip: Trip) {
        let alert = UIAlertController(title: "Delete trip", message: "Are you sure you want to permanently delete \(trip.destination!)?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteTrip)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteTrip)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeleteTrip(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteTripIndexPath {
            tableView.beginUpdates()
            
            trips.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let context:NSManagedObjectContext = appDel.managedObjectContext
            context.deleteObject(trips[indexPath.row] as NSManagedObject)
            
            trips.removeAtIndex(indexPath.row)
            
            do {
                try context.save()
            } catch {
            }
            
            deleteTripIndexPath = nil
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteTrip(alertAction: UIAlertAction!) {
        deleteTripIndexPath = nil
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        NSLog("Successfully dismissed New Trip view controller")
        
        NSLog("User cancelled New Trip")
        mixpanel?.track("Action Cancelled", properties: [
            "New Trip View": "",
            "time": NSDate()
            ])
    }
}