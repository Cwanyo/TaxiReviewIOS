//
//  SecondViewController.swift
//  TaxiReviewIOS
//
//  Created by ios-project on 12/3/2561 BE.
//

import UIKit

class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView(index: 0)
    }
    
    // recent view
    lazy var recentViewController: RecentViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "recentViewController") as! RecentViewController
        
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    // myreview view
    lazy var myReviewViewController: MyReviewViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "myReviewViewController") as! MyReviewViewController
        
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    func addViewControllerAsChildViewController(childViewController: UIViewController){
        addChildViewController(childViewController)
        
        view.addSubview(childViewController.view)
        
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
        childViewController.didMove(toParentViewController: self)
    }

    @IBAction func selectionDidChange(_ sender: UISegmentedControl) {
        updateView(index: sender.selectedSegmentIndex)
    }
    
    func updateView(index: Int){
        recentViewController.view.isHidden = !(index == 0)
        myReviewViewController.view.isHidden = (index == 0)
    }
    
}

