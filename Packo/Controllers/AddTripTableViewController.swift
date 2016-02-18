//
//  AddTripTableViewController.swift
//  Packo
//
//  Created by Rodrigo Alves on 12/20/15.
//  Copyright © 2015 Kick Ass Apps. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel

import FSCalendar

class NewTripTableViewController: UITableViewController, UINavigationControllerDelegate, UITextFieldDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    // MARK: - Constants
    let messageLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
    let dateFormatter = NSDateFormatter()
    let outputDateFormatter = NSDateFormatter()
    
    // MARK: - Variables
    var activityIndicator = UIActivityIndicatorView()
    var messageView = UIView()
    var selectingStartDate = true
    
    var startDate = NSDate()
    var endDate = NSDate()
    
    var mixpanel: Mixpanel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        outputDateFormatter.dateFormat = "E, dd MMM yyyy"
        
        destinationTextField.placeholder = NSLocalizedString("New York City", comment: "New trip's destination")
        
        // Set up the button and disable it until the user has typed a name
        saveButton.title = NSLocalizedString("Save", comment: "Save new item")
        saveButton.enabled = false
        
        // Hide tableView separators
        tableView.separatorStyle = .None
        
        let date = NSDate()
        
        let newDate3 = date.dateByAddingTimeInterval(60*60*24*29)
        
        startDateLabel.backgroundColor = UIColor(rgba: Colors.LightGray.rawValue)
        
        calendar.allowsMultipleSelection = true
    }
    
    func progressBarDisplayer(msg: String,_ indicator: Bool) {
        messageLabel.text = msg
        messageLabel.textColor = UIColor.whiteColor()
        
        messageView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageView.layer.cornerRadius = 15
        messageView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageView.addSubview(activityIndicator)
        }
        
        messageView.addSubview(messageLabel)
        view.addSubview(messageView)
    }
    
    // MARK: - FSCalendarDelegate
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        NSLog("calendar did select date \(calendar.stringFromDate(date))")
        
        if (selectingStartDate) {
            if (self.destinationTextField.text?.length > Trip.minDestinationLength) { saveButton.enabled = true }
            
            startDateLabel.text = outputDateFormatter.stringFromDate(date)
            
            selectingStartDate = false
        } else {
            endDateLabel.text = outputDateFormatter.stringFromDate(date)
            endDateLabel.backgroundColor = UIColor(rgba: Colors.LightGray.rawValue)
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - IBActions
    @IBAction func enteringDestination(sender: UITextField) {
        let textSize = destinationTextField.text!.characters.count
        
        if textSize >= Trip.minDestinationLength && !selectingStartDate {
            saveButton.enabled = true
        } else if textSize < Trip.minDestinationLength {
            saveButton.enabled = false
        }
    }
    
    @IBAction func saveItem(sender: UIBarButtonItem) {
        progressBarDisplayer(NSLocalizedString("Saving trip", comment: "Saving the new trip the database"), true)
        
        dispatch_async(dispatch_get_main_queue()) {
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                
                let entityDescription = NSEntityDescription.entityForName("Trip", inManagedObjectContext: managedObjectContext)
                let newTrip = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
                
                newTrip.setValue(IDGenerator(length: 20).id, forKey: "id")
                newTrip.setValue(self.destinationTextField.text?.trim(), forKey: "destination")
                newTrip.setValue(self.startDate, forKey: "startDate")
                newTrip.setValue(self.endDate, forKey: "endDate")
                
                do {
                    try newTrip.managedObjectContext?.save()
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        NSLog("New trip to \(newTrip.valueForKey("destination")!) saved")
                        
                        self.mixpanel?.track("Saved Object",
                            properties: [
                                "Type": Trip.entityName(),
                                "time": NSDate()
                            ])
                    })
                } catch {
                    print(error)
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.messageView.removeFromSuperview()
            }
        }
    }
}
