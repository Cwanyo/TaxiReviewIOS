//
//  TaxiDetailViewController.swift
//  TaxiReviewIOS
//
//  Created by ios-project on 15/3/2561 BE.
//

import UIKit
import Firebase

class TaxiDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var userReviewTable: UITableView!
    
    var taxiPlateNumber: String?
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userReviewTable.delegate = self
        userReviewTable.dataSource = self
        
        self.navigationItem.title = taxiPlateNumber
        
        getTaxiDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Load data from firebase
    
    func getTaxiDetail(){
        ref = Database.database().reference()
        
        //getTaxiImages()
        //getTaxiReviews()
        print(getUserImage(userId: "IGoGWE0gWNYg0VyRKdCZFhDA0w62"))
    }
   
    
    // Image
    
    func getTaxiImages() -> Bool {
        
        var check = false
        
        ref.child("Taxis/"+taxiPlateNumber!+"/Images").queryLimited(toLast: 5).observe(.value) { (snapshot) in
            
            if (snapshot.exists()){
                
                check = true
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let time = snap.key
                    let url = snap.value
                    print("time = \(time)  url = \(url!)")
                }
                
            } else {
                print("No taxi image")
            }
            
        }
        
        return check
    }
    
    func getTaxiReviews() -> Bool{
        
        var check = false
        
        // rating
        var c: Int = 0;
        var p: Int = 0;
        var s: Int = 0;
        
        ref.child("Taxis/"+taxiPlateNumber!+"/UserReviews").observe(.value) { (snapshot) in
            
            if (snapshot.exists()){
                
                check = true
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let time = snap.key
                    let review = snap.value as! NSDictionary
                    //print("key = \(time)  value = \(review!)")
                    //print(value.UserId)
                    
                    let userId = review["UserId"] as! String
                    let cleanness = review["Cleanness"] as! Int
                    let politeness = review["Politeness"] as! Int
                    let service = review["Service"] as! Int
                    let comment = review["Comment"] as! String
                    print("---")
                    print(userId)
                    print(cleanness)
                    print(politeness)
                    print(service)
                    print(comment)
                    
                }
                
            } else {
                print("No taxi review")
            }
            
        }
        
        return check
    }
    
    // TODO - Asyn 
    
    func getUserName(userId: String) -> String {
        var userName = "unknown"
        
        ref.child("Users/"+userId+"/Name").observeSingleEvent(of: .value) { (snapshot) in
            
            if (snapshot.exists()){
                
                userName = snapshot.value as! String
                
            } else {
                print("No userName : \(userId)")
            }
            
        }
        
        return userName
    }
    
    func getUserImage(userId: String) -> String {
        var userImage = "https://firebasestorage.googleapis.com/v0/b/taxireview-wvn.appspot.com/o/Assets%2Fuser.png?alt=media&token=9e6d1c02-1021-403d-9f2f-84346cd29fbc"
        
        ref.child("Users/"+userId+"/Image").observeSingleEvent(of: .value) { (snapshot) in
            
            if (snapshot.exists()){
                
                let t = snapshot.value as! String
                print(t)
                userImage = t
                
            } else {
                print("No userImage : \(userId)")
            }
            
        }
        
        return userImage
    }
    
    // Review
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userReviewCell", for: indexPath) as! UserReviewTableViewCell
        
        return cell
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
