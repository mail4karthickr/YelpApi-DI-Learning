//
//  Business.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/29/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation

struct YelpBusinessesGroup: Codable {
    var businesses: [YelpBusiness]
    
    struct YelpBusiness: Codable {
        var id: String?
        var price: String?
        var name: String?
        var location: Location
        var coordinates: Coordinates

        struct Coordinates: Codable {
            var latitude: Double
            var longitude: Double
        }
        
        struct Location: Codable {
            var city: String?
            var address3: String?
            var country: String?
            var address1: String?
        }
    }
}

extension YelpBusinessesGroup {
    var allBusinessNames: [String] {
        return businesses.map { $0.name ?? "" }
    }
}
