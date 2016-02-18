//
//  ItemsViewControllerExtension.swift
//  Packo
//
//  Created by Rodrigo Alves on 2/17/16.
//  Copyright © 2016 Packo. All rights reserved.
//

import DZNEmptyDataSet

extension ItemsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Minha mala")
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Você ainda não possui uma viagem marcada 😞")
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "my-suitcase")
    }
}