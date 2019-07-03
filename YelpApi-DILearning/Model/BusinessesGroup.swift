//
//  Business.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/29/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation

struct BusinessesGroup: Codable {
    var businesses: [Business]
    
    struct Business: Codable {
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

extension BusinessesGroup {
    var allBusinessNames: [String] {
        return businesses.map { $0.name ?? "" }
    }
}
