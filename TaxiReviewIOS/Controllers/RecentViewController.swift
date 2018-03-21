//
//  RecentViewController.swift
//  TaxiReviewIOS
//
//  Created by ios-project on 20/3/2561 BE.
//

import UIKit
import Kingfisher
import Firebase

class RecentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct recentTaxi {
        var plateNumber: String
        var Image: String
    }
    
    var handle: AuthStateDidChangeListenerHandle?
    var ref: DatabaseReference!
    
    var userId: String?
    
    @IBOutlet weak var taxiTable: UITableView!
    
    var taxis: [recentTaxi] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taxiTable.delegate = self
        taxiTable.dataSource = self
        taxiTable.rowHeight = 120.0;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user == nil){
                // if user not login, show loginViewController
                print("not log in")
               
            }else{
                // if user already logged in
                print("logged in")
                self.userId = user?.uid
                self.getListOfMyRecentViews()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func getListOfMyRecentViews(){
        ref = Database.database().reference()
        
        ref.child("Users/"+userId!+"/Recents/").queryOrderedByValue().observeSingleEvent(of: .value) { (myRecentViewData) in
            if (!myRecentViewData.exists()){
                print("My recent view not exist")
                
            }else{
                print("My recent view exist")
                
                self.taxis.removeAll()
                
                for r in myRecentViewData.children {
                    let snap = r as! DataSnapshot
                    let key = snap.key as String
                    self.getTaxiImage(taxiPlateNumber: key, completionHandler: { (tImage) in
                        
                        let t = recentTaxi(plateNumber: key, Image: tImage)
                        self.taxis.append(t)
                        
                        DispatchQueue.main.async {
                            self.taxiTable.reloadData()
                        }
                        
                    })
                }
            }
        }
    }
    
    func getTaxiImage(taxiPlateNumber: String, completionHandler: @escaping (String) -> ()){
        
        ref.child("Taxis/"+taxiPlateNumber+"/Images").queryLimited(toLast: 1).observeSingleEvent(of: .value) { (snapshot) in
            
            if (snapshot.exists()){
                
                for i in snapshot.children {
                    let snap = i as! DataSnapshot
                    let taxiImage = snap.value as! String
                    completionHandler(taxiImage)
                }
              
            } else {
                print("No taxiImage : \(taxiPlateNumber)")
                completionHandler("https://firebasestorage.googleapis.com/v0/b/taxireview-wvn.appspot.com/o/Assets%2Ftaxi.png?alt=media&token=d4ba0b58-d767-44a4-a672-e2ac9c3994dc")
            }
            
        }
        
    }

    // Table view
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taxis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taxiCell", for: indexPath) as! TaxiTableViewCell
        
        
        
        let imagePath = self.taxis[indexPath.row].Image
        let resource = ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: imagePath)
        
        cell.taxiImage.kf.setImage(with: resource)
        
        cell.taxiPlateNumber.text = taxis[indexPath.row].plateNumber
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTaxiDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let taxiDetailVC = segue.destination as? TaxiDetailViewController else {return}
        taxiDetailVC.taxiPlateNumber = taxis[(taxiTable.indexPathForSelectedRow?.row)!].plateNumber
    }

}
