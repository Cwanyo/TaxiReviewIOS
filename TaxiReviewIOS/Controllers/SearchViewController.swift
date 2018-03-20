//
//  FirstViewController.swift
//  TaxiReviewIOS
//
//  Created by ios-project on 12/3/2561 BE.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var btn_search: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tf_search.delegate = self
        btn_search.isEnabled = false
        
        tf_search.placeholder = "ทว2434"
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tf_search.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tf_search.resignFirstResponder()
    }
    
    @IBAction func searchOnEdit(_ sender: UITextField) {
        
        if (validatePlateNumber(plateNumber: tf_search.text!)){
            btn_search.isEnabled = true
        } else {
            btn_search.isEnabled = false
        }
        
    }
    
    func validatePlateNumber(plateNumber: String) -> Bool {
        // TODO - validate taxi plate number
        if (plateNumber.isEmpty){
            return false
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let taxiDetailVC = segue.destination as? TaxiDetailViewController else {return}
        taxiDetailVC.taxiPlateNumber = tf_search.text
    }

}

