//
//  Business.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 7/4/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import UIKit
import CoreLocation

protocol BusinessProtocol {
    func adaptBusinessFromYLP() -> Business
}

protocol YelpBusinessesGroupProtocol {
    func adaptAllYLPBusiness() -> [Business]
}

extension YelpBusinessesGroup.YelpBusiness.Coordinates {
    func getCoordinateFromYLP() -> BusinessCoordinates {
        return BusinessCoordinates(latitude: self.latitude,
                                   longitude: self.longitude)
    }
}

extension YelpBusinessesGroup.YelpBusiness: BusinessProtocol {
    func adaptBusinessFromYLP() -> Business {
        return Business(id: id,
                        name: name,
                        coordinates: coordinates.getCoordinateFromYLP(),
                        isFavourite: false)
    }
}

extension YelpBusinessesGroup {
    func adaptAllYLPBusiness() -> [Business] {
        return self.businesses.map { $0.adaptBusinessFromYLP() }
    }
}

struct Business: Codable {
    var id: String?
    var name: String?
    var coordinates: BusinessCoordinates?
    var isFavourite: Bool
}

struct BusinessCoordinates: Codable {
    let latitude, longitude: Double
}
