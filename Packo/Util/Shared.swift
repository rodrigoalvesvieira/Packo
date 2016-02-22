//
//  Shared.swift
//  Packo
//
//  Created by Rodrigo Alves on 2/22/16.
//  Copyright © 2016 Packo. All rights reserved.
//

import Foundation
import Mixpanel

struct Shared {
    struct AppDel {
        static let appDel = UIApplication.sharedApplication().delegate as? AppDelegate
    }
    
    struct LayoutHelpers {
        static let navigationBarFont = UIFont(name: "AvenirNext-Medium", size: 20)
    }
    
    struct Color {
        static let white = UIColor.whiteColor()
        static let lightBlue = UIColor(rgba: Colors.LightBlue.rawValue)
        static let darkBlue = UIColor(rgba: Colors.DarkBlue.rawValue)
        static let gray = UIColor(rgba: Colors.Grey.rawValue)
        static let lightGray = UIColor(rgba: Colors.LightGray.rawValue)
    }
    
    struct Storyboard {
        static let main = UIStoryboard(name: "Main", bundle: nil)
    }
    
    struct MixpanelInstance {
        static let mixpanelInstance = Mixpanel.sharedInstance()
    }
    
    struct NC {
        static let notificationCenter = NSNotificationCenter.defaultCenter()
    }
}