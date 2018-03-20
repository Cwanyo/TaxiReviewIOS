//
//  Review.swift
//  TaxiReviewIOS
//
//  Created by ios-project on 17/3/2561 BE.
//

import Foundation

class Review {
    
    var userId: String
    var userName: String
    var userImage: String
    var cleanness: Int
    var politeness: Int
    var service: Int
    var comment: String
    
    init() {
        self.userId = ""
        self.userName = ""
        self.userImage = ""
        self.cleanness = 0
        self.politeness = 0
        self.service = 0
        self.comment = ""
    }
}
