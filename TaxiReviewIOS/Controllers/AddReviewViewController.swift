//
//  AddReviewViewController.swift
//  TaxiReviewIOS
//
//  Created by ios-project on 15/3/2561 BE.
//

import UIKit

class AddReviewViewController: UIViewController {

    
    @IBOutlet weak var lb_service: UILabel!
    @IBOutlet weak var lb_politeness: UILabel!
    @IBOutlet weak var lb_cleanness: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Review"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
