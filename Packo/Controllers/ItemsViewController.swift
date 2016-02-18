//
//  ItemsViewController.swift
//  Packo
//
//  Created by Rodrigo Alves on 9/18/15.
//  Copyright © 2015 Kick Ass Apps. All rights reserved.
//

import UIKit
import CoreData

import Mixpanel

import DZNEmptyDataSet

class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Constants
    var mixpanel: Mixpanel?
    let outputDateFormatter = NSDateFormatter()
    
    // MARK: - Variables
    var items: [Item] = []
    var trip: Trip?
    var deleteItemIndexPath: NSIndexPath? = nil
    
    var currentTemperature: String?
    var currentIconString = "default"
    
    var fromPastTrip: Bool?
    var hasWeatherData: Bool?
    
    var searchController: UISearchController!
    var searchResults:[Item] = []
    
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
    
    lazy var fetchedItemsResultsController: NSFetchedResultsController = {
        let tripsFetchRequest = NSFetchRequest(entityName: "Item")
        let primarySortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 20)!]

        UIApplication.sharedApplication().statusBarStyle = .Default
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            
        }
        
        outputDateFormatter.dateFormat = "MMM dd"
        
        tableView.tableFooterView = UIView()
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    deinit {
        self.tableView.emptyDataSetSource = nil
        self.tableView.emptyDataSetDelegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
        
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "peekItemDetail" { return false }
        return true
    }
    
    // Mark: - UITableViewDataSource delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell") as! WeatherTableViewCell
        
        return cell
    }
    
    @IBAction func unwindToItemsViewController(segue: UIStoryboardSegue) {
    }
}
