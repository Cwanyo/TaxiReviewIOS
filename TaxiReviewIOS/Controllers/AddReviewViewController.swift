//
//  AddReviewViewController.swift
//  TaxiReviewIOS
//
//  Created by ios-project on 15/3/2561 BE.
//

import UIKit
import Firebase

class AddReviewViewController: UIViewController {

    
    @IBOutlet weak var lb_service: UILabel!
    @IBOutlet weak var lb_politeness: UILabel!
    @IBOutlet weak var lb_cleanness: UILabel!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user == nil){
                // if user not login, show loginViewController
                print("not log in")
                self.loginViewController.view.isHidden = false
                self.navigationItem.title = "Log in"
            }else{
                // if user already logged in, show profileViewController
                print("logged in")
                self.loginViewController.view.isHidden = true
                self.navigationItem.title = "Add Review"
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
    
    func addViewControllerAsChildViewController(childViewController: UIViewController){
        
        print("call")
        addChildViewController(childViewController)
        
        view.addSubview(childViewController.view)
        
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        childViewController.didMove(toParentViewController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    @IBAction func serviceSlider(_ sender: UISlider) {
        lb_service.text = String(Int(sender.value))
    }
    
    @IBAction func politenessSlider(_ sender: UISlider) {
        lb_politeness.text = String(Int(sender.value))
    }
    
    @IBAction func cleannessSlider(_ sender: UISlider) {
        lb_cleanness.text = String(Int(sender.value))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
