//
//  ItemsViewControllerExtension.swift
//  Packo
//
//  Created by Rodrigo Alves on 2/17/16.
//  Copyright © 2016 Packo. All rights reserved.
//

import DZNEmptyDataSet

extension ItemsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIViewControllerPreviewingDelegate {
    
    // MARK: - DZNEmptyDataSetSource
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [ NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 28)!]
        let string = NSLocalizedString("My suitcase", comment: "")
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // MARK: - DZNEmptyDataSetSource
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [ NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 18)!]
        let string = NSLocalizedString("You don't have any trip planned yet 😞", comment: "")
        
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // MARK: - DZNEmptyDataSetDelegate
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "my-suitcase")
    }
    
    // MARK: - UIViewControllerPreviewingDelegate
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        guard let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ItemDetailViewController") as? ItemDetailViewController else { return nil }
        
        viewController.preferredContentSize = CGSize(width: 0, height: 0)
        
        return viewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
}