//
//  Taxi.swift
//  TaxiReviewIOS
//
//  Created by ios-project on 17/3/2561 BE.
//

import Foundation

struct Taxi {
    var plateNumber: String
    var images: [String]
    var avgCleanness: Double
    var avgPoliteness: Double
    var avgService: Double
    var userReview: [Review]
}
