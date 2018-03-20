//
//  TaxiDetailViewController.swift
//  TaxiReviewIOS
//
//  Created by ios-project on 15/3/2561 BE.
//

import UIKit
import Firebase
import Kingfisher

class TaxiDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var lb_service: UILabel!
    @IBOutlet weak var lb_politeness: UILabel!
    @IBOutlet weak var lb_cleanness: UILabel!
        
    @IBOutlet weak var userReviewTable: UITableView!
    
    var taxiPlateNumber: String?
    
    var taxi = Taxi()
    
    var ref: DatabaseReference!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userReviewTable.delegate = self
        userReviewTable.dataSource = self
        
        self.navigationItem.title = taxiPlateNumber
        
        getTaxiDetail()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user != nil){
                // if user already logged in
                self.addToUserRecentView(userId: (user?.uid)!)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func addToUserRecentView(userId: String){
        self.ref.child("Users/"+userId+"/Recents/"+self.taxiPlateNumber!).setValue(Int64(Date().timeIntervalSince1970 * 1000))
        print("Added to my review")
    }
    
    // Load data from firebase
    
    func getTaxiDetail(){
        ref = Database.database().reference()
        
        getTaxiImages { (result) in
            self.showImageSlide()
        }
        
        getTaxiReviews()
        
    }
   
    
    // Image
    
    func getTaxiImages(completionHandler: @escaping (Bool) -> ()){
    
        ref.child("Taxis/"+taxiPlateNumber!+"/Images").queryLimited(toLast: 5).observeSingleEvent(of: .value) { (snapshot) in
            
            if (snapshot.exists()){
                
                // Clear taxi image
                self.taxi.images.removeAll()
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    
                    let url = snap.value as! String
                    
                    // Add each image to object
                    self.taxi.images.append(url)
                    print("get images data : \(self.taxi.images.count)")
                }
                
                completionHandler(true)
            } else {
                print("No taxi image")
                
                // Default taxi image
                let url = "https://firebasestorage.googleapis.com/v0/b/taxireview-wvn.appspot.com/o/Assets%2Ftaxi.png?alt=media&token=d4ba0b58-d767-44a4-a672-e2ac9c3994dc"
                self.taxi.images.append(url)
                
                completionHandler(false)
            }
            
        }
        
    }
    
    func getTaxiReviews(){
       
        
        
        ref.child("Taxis/"+taxiPlateNumber!+"/UserReviews").observe(.value) { (snapshot) in
            
            if (snapshot.exists()){
                
                // Rating
                var tuser: Int = 0
                var c: Int = 0
                var p: Int = 0
                var s: Int = 0
                
                // Clear taxi review
                self.taxi.userReview.removeAll()
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let review = snap.value as! NSDictionary
                    
                    // Cast
                    let userId = review["UserId"] as! String
                    let cleanness = review["Cleanness"] as! Int
                    let politeness = review["Politeness"] as! Int
                    let service = review["Service"] as! Int
                    let comment = review["Comment"] as! String
                    
                    
                    var userName: String?
                    var userImage: String?
                   
                    self.getUserName(userId: userId, completionHandler: { (uName) in
                        userName = uName
                        
                        self.getUserImage(userId: userId, completionHandler: { (uImage) in
                            userImage = uImage
                            
                            //print("-----")
                            let r = Review()
                            r.userId = userId
                            r.userName = userName!
                            r.userImage = userImage!
                            r.cleanness = cleanness
                            r.politeness = politeness
                            r.service = service
                            r.comment = comment
                            //print(r)
                            
                            // Update rating
                            tuser+=1
                            c+=r.cleanness
                            p+=r.politeness
                            s+=r.service
                           
                            self.lb_service.text = String(format:"%.2f", Double(s)/Double(tuser))
                            self.lb_cleanness.text = String(format:"%.2f", Double(c)/Double(tuser))
                            self.lb_politeness.text = String(format:"%.2f", Double(p)/Double(tuser))
                            
                            // Add each review to object
                            self.taxi.userReview.append(r)
                            
                            // Call table to reload
                            print("get review data : \(self.taxi.userReview.count)")
                            
                            DispatchQueue.main.async {
                                self.userReviewTable.reloadData()
                            }
                        })
                        
                    })
                    
                }
                
            } else {
                print("No taxi review")
            }
            
        }
        
    }
    
    // TODO - Asyn
    
    func getUserName(userId: String, completionHandler: @escaping (String) -> ()){
        
        ref.child("Users/"+userId+"/Name").observeSingleEvent(of: .value) { (snapshot) in
            
            if (snapshot.exists()){
                
                let userName = snapshot.value as! String
                completionHandler(userName)
                
            } else {
                print("No userName : \(userId)")
                completionHandler("unknown")
            }
            
        }
        
    }
    
    func getUserImage(userId: String, completionHandler: @escaping (String) -> ()){
        
        ref.child("Users/"+userId+"/Image").observeSingleEvent(of: .value) { (snapshot) in
            
            if (snapshot.exists()){
                
                let userImage = snapshot.value as! String
                completionHandler(userImage)
                
            } else {
                print("No userImage : \(userId)")
                completionHandler("https://firebasestorage.googleapis.com/v0/b/taxireview-wvn.appspot.com/o/Assets%2Fuser.png?alt=media&token=9e6d1c02-1021-403d-9f2f-84346cd29fbc")
            }
            
        }
        
    }
    
    // Show image slide
    
    func showImageSlide(){
        
        // Remove all subview
        /*let subviews = self.imageScrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }*/
        
        var c = 0
        for i in (taxi.images){
            let imageView = UIImageView()
            
            let resource = ImageResource(downloadURL: URL(string: i)!, cacheKey: i)
            imageView.kf.setImage(with: resource)
            
            imageView.contentMode = .scaleAspectFit
            
            let xPos = Int(self.view.frame.width) * c
            imageView.frame = CGRect(x: CGFloat(xPos), y: 0, width: self.imageScrollView.frame.width, height: self.imageScrollView.frame.height)
            
            imageScrollView.contentSize.width = imageScrollView.frame.width * CGFloat(c + 1)
            imageScrollView.addSubview(imageView)
            
            c+=1
        }
    }
   
    // Review Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taxi.userReview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userReviewCell", for: indexPath) as! UserReviewTableViewCell
        
        let imagePath = self.taxi.userReview[indexPath.row].userImage
        let resource = ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: imagePath)
        cell.userImage.kf.setImage(with: resource)
        
        cell.userName.text = taxi.userReview[indexPath.row].userName
        
        cell.userComment.text = taxi.userReview[indexPath.row].comment
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addReviewVC = segue.destination as? AddReviewViewController else {return}
        addReviewVC.taxiPlateNumber = taxiPlateNumber
    }

}
