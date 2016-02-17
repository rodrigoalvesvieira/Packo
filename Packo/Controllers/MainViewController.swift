//
//  MainViewController.swift
//  Packo
//
//  Created by Rodrigo Alves on 2/17/16.
//  Copyright © 2016 Packo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // First VC
        let itemsViewController = storyboard.instantiateViewControllerWithIdentifier("ItemsNavigationViewController") as! UINavigationController
        
        self.addChildViewController(itemsViewController)
        self.scrollView.addSubview(itemsViewController.view)
        itemsViewController.didMoveToParentViewController(self)
        itemsViewController.view.frame = self.scrollView.bounds
        
        // Second VC
        let tripsViewController = storyboard.instantiateViewControllerWithIdentifier("TripsNavigationViewController") as! UINavigationController
        
        var frame2 = tripsViewController.view.frame
        frame2.origin.x = self.view.frame.size.width
        tripsViewController.view.frame = frame2
        
        let tripsViewControllerOrigin = tripsViewController.view.frame.origin
        
        tripsViewController.view.frame = self.scrollView.bounds
        tripsViewController.view.frame.origin = tripsViewControllerOrigin
        
        self.addChildViewController(tripsViewController)
        self.scrollView.addSubview(tripsViewController.view)
        tripsViewController.didMoveToParentViewController(self)
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height - statusBarHeight - 66)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

