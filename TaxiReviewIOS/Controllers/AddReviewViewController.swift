//
//  AddReviewViewController.swift
//  TaxiReviewIOS
//
//  Created by ios-project on 15/3/2561 BE.
//

import UIKit
import Firebase

class AddReviewViewController: UIViewController, UITextViewDelegate {

    var taxiPlateNumber: String?
    var userId: String?
    
    @IBOutlet weak var lb_service: UILabel!
    @IBOutlet weak var lb_politeness: UILabel!
    @IBOutlet weak var lb_cleanness: UILabel!
    @IBOutlet weak var tv_comment: UITextView!
    
    @IBOutlet weak var btn_submit: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tv_comment.delegate = self
        btn_submit.isEnabled = false
        btn_submit.alpha = 0.5
    }

    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user == nil){
                // if user not login, show loginViewController
                print("not log in")
                self.loginViewController.view.isHidden = false
                self.navigationItem.title = "Log in"
            }else{
                // if user already logged in
                print("logged in")
                self.loginViewController.view.isHidden = true
                self.navigationItem.title = "Add Review"
                self.userId = user?.uid
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
    
    // Add review
    
    @IBAction func serviceSlider(_ sender: UISlider) {
        sender.setValue(Float(lroundf(sender.value)), animated: true)
        lb_service.text = String(Int(sender.value))
    }
    
    @IBAction func politenessSlider(_ sender: UISlider) {
        sender.setValue(Float(lroundf(sender.value)), animated: true)
        lb_politeness.text = String(Int(sender.value))
    }
    
    @IBAction func cleannessSlider(_ sender: UISlider) {
        sender.setValue(Float(lroundf(sender.value)), animated: true)
        lb_cleanness.text = String(Int(sender.value))
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (validatePlateComment(comment: tv_comment.text!)){
            btn_submit.isEnabled = true
            btn_submit.alpha = 1
        } else {
            btn_submit.isEnabled = false
            btn_submit.alpha = 0.5
        }
    }
    
    func validatePlateComment(comment: String) -> Bool {
        // TODO - validate comment
        if (comment.isEmpty){
            return false
        }
        
        return true
    }
    
    var ref: DatabaseReference!

    func addReviewDB(ref: DatabaseReference,key: String, review: [String : Any]){
        // add review
        ref.child(key).setValue(review, withCompletionBlock: { (err, ref) in
            if err == nil {
                print("Create and add new review of taxi in firedatabase")
                // add my review
                self.ref.child("Users/"+self.userId!+"/Reviews/"+self.taxiPlateNumber!).setValue(true)
                print("Added to my review")
            }
        })
        
        // go back to taxi detailpage
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addReview(_ sender: UIButton) {
        print("addReview")
        
        ref = Database.database().reference()
        
        let taxiReviewsRef = ref.child("Taxis/"+taxiPlateNumber!+"/UserReviews")
        let key = taxiReviewsRef.childByAutoId().key
        let review = ["UserId": userId!,
                      "Service": Int(lb_service.text!)!,
                      "Politeness": Int(lb_politeness.text!)!,
                      "Cleanness": Int(lb_cleanness.text!)!,
                      "Comment": tv_comment.text,
                      ] as [String : Any]
        
        taxiReviewsRef.observeSingleEvent(of: .value) { (taxiReview ) in
            if(!taxiReview.exists()){
                print("Taxi review not exist")
                // add review
                self.addReviewDB(ref: taxiReviewsRef, key: key, review: review)
            }else{
                print("Taxi review exist")
                
                // check user review already exist or not
                let currUserReview = self.ref.child("Taxis/"+self.taxiPlateNumber!+"/UserReviews").queryOrdered(byChild: "UserId").queryEqual(toValue: self.userId)
                
                currUserReview.observeSingleEvent(of: .value, with: { (curData) in
                    if(!curData.exists()){
                        print("Current user review never exist")
                        // add review
                        self.addReviewDB(ref: taxiReviewsRef, key: key, review: review)
                    }else{
                        print("Current user review already exist")
                        // delete all the previous review of the current user
                        for c in curData.children {
                            let snap = c as! DataSnapshot
                            let key = snap.key as String
                            
                            self.ref.child("Taxis/"+self.taxiPlateNumber!+"/UserReviews/"+key).removeValue(completionBlock: { (err, ref) in
                                if err == nil {
                                    print("Deleted review at", key)
                                }
                            })
                        }
                        // add review
                        self.addReviewDB(ref: taxiReviewsRef, key: key, review: review)
                    }
                })
                
                
            }
        }
        
    }
    

}
