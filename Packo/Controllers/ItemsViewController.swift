//
//  ItemsViewController.swift
//  Packo
//
//  Created by Rodrigo Alves on 9/18/15.
//  Copyright © 2015 Kick Ass Apps. All rights reserved.
//

import UIKit
import CoreData

import DZNEmptyDataSet

class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Constants
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
        let primarySortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        
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
        
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSFontAttributeName: Shared.LayoutHelpers.navigationBarFont!
        ]

        UIApplication.sharedApplication().statusBarStyle = .Default
        
        Shared.NC.notificationCenter.addObserver(self, selector: "newItemAdded", name: "newItemAdded", object: nil)
        Shared.NC.notificationCenter.addObserver(self, selector: "newTripAdded", name: "newTripAdded", object: nil)

        do {
            try fetchedResultsController.performFetch()
            let trips = fetchedResultsController.fetchedObjects as? [Trip]
            
            if let currentTrip = trips!.first {
                trip = currentTrip
                
                NSLog("Current trip found: \(currentTrip.destination as String!)")
                
                Shared.DB.currentTrip = currentTrip
                
                self.fetchWeatherInfo()
                
                do {
                    try fetchedItemsResultsController.performFetch()
                    self.items = (fetchedItemsResultsController.fetchedObjects as? [Item])!
                    
                    NSLog("Total of \(self.items.count) items found.")
                }
            } else {
                NSLog("No trip was found!")
            }
            
        } catch {
            
        }
        
        outputDateFormatter.dateFormat = "MMM dd"
        
        tableView.tableFooterView = UIView()
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        Shared.MixpanelInstance.mixpanelInstance.track("View Controller Loaded", properties: ["View Controller Name": "ItemsViewController"])
    }
    
    deinit {
        self.tableView.emptyDataSetSource = nil
        self.tableView.emptyDataSetDelegate = nil
    }
    
    func newItemAdded() {
        NSLog("Reloading items table view data.")
        
        do {
            try fetchedItemsResultsController.performFetch()
            self.items = (fetchedItemsResultsController.fetchedObjects as? [Item])!
            
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        } catch {
        }
    }
    
    func newTripAdded() {
        NSLog("Reloading items table view for new trip.")
        
        do {
            try fetchedResultsController.performFetch()
            let trips = fetchedResultsController.fetchedObjects as? [Trip]
            
            if let currentTrip = trips!.first {
                trip = currentTrip
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    self.fetchWeatherInfo()
                }
            }
            
        } catch {
        }
    }
    
    func fetchWeatherInfo() {
        var config: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist") {
            config = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = config, geocodingAPIKey = dict.valueForKey("googleGeocodingAPIKey") as? String, forecastIOAPIKey = dict.valueForKey("forecastIOAPIKey") as? String {
            
            let geocoder = Geocoder(apiKey: geocodingAPIKey)
            
            if let currentTrip = trip {
                if let geolocation = geocoder.geocode(place: currentTrip.destination) {
                    let forecastIO = ForecastIO(apiKey: forecastIOAPIKey)
                    
                    if let currentWeather = forecastIO.getCurrentWeather("\(geolocation.latitude!),\(geolocation.longitude!)") {
                        
                        currentTemperature = "\(currentWeather.temperature)"
                        currentIconString = currentWeather.iconString
                    }
                }
            }
        }
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
        if let _ = trip {
            return items.count + 1
        } else {
            return items.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell") as! WeatherTableViewCell
            cell.destinationLabel.text = trip?.destination
            cell.durationLabel.text = outputDateFormatter.stringFromDate((trip?.startDate)!)
            
            if let endDate = trip?.endDate {
                let endDateStr = outputDateFormatter.stringFromDate(endDate)
                
                if let durationLabelText = cell.durationLabel.text {
                    cell.durationLabel.text = durationLabelText + " - " + endDateStr
                }
            }
            
            if let rawTemperature = currentTemperature, temperature = Double(rawTemperature) {
                cell.temperatureLabel.text = "\(Int(temperature))"
            }
            
            cell.weatherIcon.image = UIImage(named: currentIconString)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("itemCell") as! ItemTableViewCell
            tableView.rowHeight = 80
            
            let item = items[indexPath.row - 1]
            cell.itemNameLabel.text = item.name
            
            cell.thumbnailImageView.image = UIImage(data: item.picture, scale: 1.0)?.circle
            cell.thumbnailImageView.layer.borderWidth = 1.0
            cell.thumbnailImageView.layer.masksToBounds = false
            
            cell.thumbnailImageView.layer.borderColor = UIColor.whiteColor().CGColor
            cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.width / 2
            cell.thumbnailImageView.clipsToBounds = true
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        //if indexPath.row == 0 { return .None }
        //return .Delete
        
        return .None
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            deleteItemIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 1)
            
            let itemToDelete = items[indexPath.row - 1]
            confirmDelete(itemToDelete)
        }
    }
    
    ///  Returns `true` when there is at least one item available. Returns `false` otherwise.
    ///
    func hasZeroItems() -> Bool {
        return items.count == 0
    }
    
    func getCurrentWeatherData() -> Void {
        var config: NSDictionary?
        
        if let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist") {
            config = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = config, forecastIOapiKey = dict.valueForKey("forecastIOAPIKey") as? String, googleGeocodingAPIKey = dict.valueForKey("googleGeocodingAPIKey") as? String {
            
            let geocoder = Geocoder(apiKey: googleGeocodingAPIKey)
            
            if let geoInfo = geocoder.geocode(place: trip?.destination) {
                let coordinates = geoInfo.toString()
                
                NSLog("Fetched coordinates for \(geoInfo.locationName) are \(coordinates)")
                
                let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastIOapiKey)/")
                let forecastURL = NSURL(string: coordinates, relativeToURL: baseURL)
                
                let sharedSession = NSURLSession.sharedSession()
                let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
                    if error == nil {
                        let dataObject = NSData(contentsOfURL: location!)
                        
                        if let weatherDictionary: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(dataObject!, options: [])) as? NSDictionary {
                            
                            let currentWeather = Weather(weatherDictionary: weatherDictionary)
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.currentTemperature = "\(currentWeather.toCelsius())"
                                self.currentIconString = currentWeather.iconString
                                
                                NSLog("Icon string is \(self.currentIconString)")
                            })
                        }
                        
                    } else {
                        let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data, conectivity error", preferredStyle: .Alert)
                        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        networkIssueController.addAction(okButton)
                        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                        networkIssueController.addAction(cancelButton)
                        
                        self.presentViewController(networkIssueController, animated: true, completion: nil)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        })
                    }
                })
                
                downloadTask.resume()
            }
        }
    }
    
    func confirmDelete(item: Item) {
        let alert = UIAlertController(title: "Delete item", message: "Are you sure you want to permanently delete \(item.name!)?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteItem)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteItem)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func handleDeleteItem(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteItemIndexPath {
            tableView.beginUpdates()
            
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let context:NSManagedObjectContext = appDel.managedObjectContext
            context.deleteObject(items[indexPath.row - 1] as NSManagedObject)
            
            do {
                try context.save()
                
                items.removeAtIndex(indexPath.row - 1)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            } catch {
            }
            
            deleteItemIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteItem(alertAction: UIAlertAction!) {
        deleteItemIndexPath = nil
    }
    
    @IBAction func createTripOrItemButtonPress(sender: UIBarButtonItem) {

        let newItemController = Shared.Storyboard.main.instantiateViewControllerWithIdentifier("AddItemTableViewNavigationController") as! UINavigationController
        
        let newTripController = Shared.Storyboard.main.instantiateViewControllerWithIdentifier("AddTripTableViewNavigationController") as! UINavigationController
        
        if let _ = trip {
            self.presentViewController(newItemController, animated: true, completion: nil)
        } else {
            self.presentViewController(newTripController, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToItemsViewController(segue: UIStoryboardSegue) {
    }
}
