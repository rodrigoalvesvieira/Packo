//
//  AddItemTableViewController.swift
//  Packo
//
//  Created by Rodrigo Alves on 3/8/15.
//  Copyright (c) 2015 Rodrigo Alves. All rights reserved.
//

import UIKit
import CoreData
import CoreSpotlight
import Mixpanel

class NewItemTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: - Constants
    let imagePicker = UIImagePickerController()
    let messageLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    // MARK: - Variables
    var activityIndicator = UIActivityIndicatorView()
    var messageView = UIView()
    
    var trip: Trip?
    var mixpanel: Mixpanel?
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 20)!]
        
        navigationItem.title = NSLocalizedString("New item", comment: "Adding new item")
        
        nameTextField.placeholder = NSLocalizedString("Name", comment: "New item's name")
        
        // Set up the button and disable it until the user has typed a name
        saveButton.title = NSLocalizedString("Save", comment: "Save new item")
        saveButton.enabled = false
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "handleSwipeRight:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        
        tableView.addGestureRecognizer(swipeRight)
        
        let buttonColor = UIColor(rgba: Colors.Button.rawValue)
        
        cancelButton.tintColor = buttonColor
        saveButton.tintColor = buttonColor
        
        imageView.backgroundColor = buttonColor
        
        print("nosso trip eh \(trip?.destination)")
        
        // Hide tableView separators
        tableView.separatorStyle = .None
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipeRight(sender: UISwipeGestureRecognizer!) {
        dismissViewControllerAnimated(true, completion: {})
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:
        NSIndexPath) {
            imagePicker.delegate = self
            
            if indexPath.row == 0 {
                
                let optionMenu = UIAlertController(title: nil, message: "Escolher foto", preferredStyle: .ActionSheet)
                
                // Choose to delete the current picture
                let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: "Delete the new item's picture"), style: .Destructive, handler: {
                    (alert: UIAlertAction) -> Void in
                    
                    self.imageView.image = UIImage(named: "add-photo")
                    self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
                    self.imageView.clipsToBounds = true
                })
                
                // Take a picture with the Camera
                let takePictureAction = UIAlertAction(title: NSLocalizedString("Take photo", comment: "Take the new item's photo"), style: .Default, handler: {
                    (alert: UIAlertAction) -> Void in
                    
                    if UIImagePickerController.isCameraDeviceAvailable( UIImagePickerControllerCameraDevice.Front) {
                        
                        self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                        
                        self.presentViewController(self.imagePicker, animated: true, completion: {
                            self.normalizeImage()
                        })
                    }
                })
                
                // Pick a picture from the Camera Roll
                let choosePicureAction = UIAlertAction(title: NSLocalizedString("Choose photo", comment: "Choose the new item's photo"), style: .Default, handler: {
                    (alert: UIAlertAction) -> Void in
                    
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
                        
                        self.imagePicker.sourceType = .PhotoLibrary
                        self.imagePicker.allowsEditing = false
                        
                        self.presentViewController(self.imagePicker, animated: true, completion: {
                            self.normalizeImage()
                        })
                    }
                })
                
                // Cancel the whole thing
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel the choosing of the new item's picture"), style: .Cancel, handler: {
                    (alert: UIAlertAction) -> Void in
                })
                
                optionMenu.addAction(deleteAction)
                optionMenu.addAction(takePictureAction)
                optionMenu.addAction(choosePicureAction)
                optionMenu.addAction(cancelAction)
                
                self.presentViewController(optionMenu, animated: true, completion: nil)
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func normalizeImage() {
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
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
    
    func createSearchableItemFromItem(item: Item) -> CSSearchableItem {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: "image" as String)
        
        attributeSet.title = item.name
        attributeSet.thumbnailData = UIImageJPEGRepresentation(UIImage(data: item.picture)!, 1.0)
        
        return CSSearchableItem(uniqueIdentifier: item.id, domainIdentifier: "me.kickassapps.Packo.items", attributeSet: attributeSet)
    }
    
    @IBAction func enteringName(sender: UITextField) {
        let textSize = nameTextField.text!.characters.count
        
        if  textSize >= Item.minNameLength {
            saveButton.enabled = true
        } else if textSize < Item.minNameLength {
            saveButton.enabled = false
        }
    }
    
    @IBAction func saveItem(sender: UIBarButtonItem) {
        self.progressBarDisplayer(NSLocalizedString("Saving item", comment: "Saving the new item do the database"), true)
        
        dispatch_async(dispatch_get_main_queue()) {
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                
                let entityDescription = NSEntityDescription.entityForName("Item", inManagedObjectContext: managedObjectContext)
                let newItem = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
                
                newItem.setValue(IDGenerator(length: 20).id, forKey: "id")
                newItem.setValue(self.nameTextField.text?.trim(), forKey: "name")
                
                if let itemImage = self.imageView.image {
                    guard let imageData = UIImageJPEGRepresentation(itemImage, 1) else {
                        NSLog("JPG Conversion Error")
                        return
                    }
                    
                    newItem.setValue(imageData, forKey: "picture")
                }
                
                do {
                    try newItem.managedObjectContext?.save()
                    
                    if let item = newItem as? Item {
                        let searchableItem = self.createSearchableItemFromItem(item)
                        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([searchableItem], completionHandler: { error -> Void in
                            if error == nil {
                                NSLog("Item successfully indexed")
                                
                                self.notificationCenter.postNotificationName("newItemAdded", object: nil)
                            } else {
                                NSLog((error?.localizedDescription)!)
                            }
                        })
                    }
                    
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        NSLog("New trip to \(newItem.valueForKey("name")!) saved")
                        
                        self.mixpanel?.track("Saved Object",
                            properties: [
                                "Type": Item.entityName(),
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
