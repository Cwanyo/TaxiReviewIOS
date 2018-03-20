//
//  TaxiTableViewCell.swift
//  TaxiReviewIOS
//
//  Created by ios-project on 20/3/2561 BE.
//

import UIKit

class TaxiTableViewCell: UITableViewCell {

    
    @IBOutlet weak var taxiImage: UIImageView!
    @IBOutlet weak var taxiPlateNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Rounded user image
        taxiImage.layer.cornerRadius = taxiImage.frame.width / 2
        taxiImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
