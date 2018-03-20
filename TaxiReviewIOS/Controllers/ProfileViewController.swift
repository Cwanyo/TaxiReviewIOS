//
//  ProfileViewController.swift
//  TaxiReviewIOS
//
//  Created by ios-project on 15/3/2561 BE.
//

import UIKit
import Kingfisher
import Firebase
import GoogleSignIn

class ProfileViewController: UIViewController{

    @IBOutlet weak var lb_username: UILabel!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var tf_email: UITextField!
    
    var ref: DatabaseReference!
    
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
            }else{
                // if user already logged in, show profileViewController
                print("logged in")
                self.loginViewController.view.isHidden = true
                
                // set user info
                self.lb_username.text = user?.displayName
                
                let resource = ImageResource(downloadURL: (user?.providerData[0].photoURL)!, cacheKey: user?.providerData[0].photoURL?.absoluteString)
                self.img_profile.kf.setImage(with: resource)
                
                self.tf_email.text = user?.email
                
                self.ref = Database.database().reference()
                
                // update user info in firebase
                let r = self.ref.child("Users").child((user?.uid)!)
               
                r.child("Email").setValue(user?.email)
                r.child("Name").setValue(user?.displayName)
                r.child("Image").setValue(user?.providerData[0].photoURL?.absoluteString)
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
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
    
    @IBAction func signOut(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print ("Successfully signing out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        /*GIDSignIn.sharedInstance().signOut()
        print ("Successfully signing out")*/
    }
    
    
}
