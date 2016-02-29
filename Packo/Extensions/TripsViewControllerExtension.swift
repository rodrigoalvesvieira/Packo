//
//  TripsViewControllerExtension.swift
//  Packo
//
//  Created by Rodrigo Alves on 2/17/16.
//  Copyright © 2016 Packo. All rights reserved.
//

import DZNEmptyDataSet

extension TripsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [ NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 28)!]
        let string = NSLocalizedString("My trips", comment: "")
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [ NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 18)!]
        return NSAttributedString(string: "You don't have any trip planned yet 😞", attributes: attributes)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "my-trips")
    }
}