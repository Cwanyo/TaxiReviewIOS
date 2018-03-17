//
//  Taxi.swift
//  TaxiReviewIOS
//
//  Created by ios-project on 17/3/2561 BE.
//

import Foundation

class Taxi {
    var plateNumber: String
    var images: [String]
    var avgCleanness: Double
    var avgPoliteness: Double
    var avgService: Double
    var userReview: [Review]
    
    init() {
        self.plateNumber = ""
        self.images = [String]()
        self.avgCleanness = 0
        self.avgPoliteness = 0
        self.avgService = 0
        self.userReview = [Review]()
    }
    
}

