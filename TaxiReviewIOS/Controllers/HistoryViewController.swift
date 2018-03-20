//
//  SecondViewController.swift
//  TaxiReviewIOS
//
//  Created by ios-project on 12/3/2561 BE.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController {

    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView(index: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user == nil){
                // if user not login, show loginViewController
                print("not log in")
                self.navigationItem.titleView?.isHidden = true
                self.loginViewController.view.isHidden = false
                self.navigationItem.title = "Log in"
            }else{
                // if user already logged in
                self.navigationItem.titleView?.isHidden = false
                print("logged in")
                self.loginViewController.view.isHidden = true
            }
        }
    }
    
    // Login view
    lazy var loginViewController: LoginViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
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

