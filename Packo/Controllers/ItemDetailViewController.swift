//
//  ItemDetailViewController.swift
//  Packo
//
//  Created by Rodrigo Alves on 2/29/16.
//  Copyright © 2016 Packo. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var itemImage: UIImageView!
    
    // MARK: - Variables
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let itemPicture = item?.picture {
            self.itemImage.image = UIImage(data: itemPicture)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        let regularAction = UIPreviewAction(title: "Regular", style: .Default) { (action: UIPreviewAction, vc: UIViewController) -> Void in
            
        }
        
        let message = NSLocalizedString("Delete", comment: "")
        
        let destructiveAction = UIPreviewAction(title: message, style: .Destructive) { (action: UIPreviewAction, vc: UIViewController) -> Void in
        }
        
        return [regularAction, destructiveAction]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
