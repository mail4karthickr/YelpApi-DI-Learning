//
//  BusinessMerger.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 7/5/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation

class BusinessMerger {
    func merge(favouriteBusinesses favBusinesses: [Business], withAllBusinesses allBusinesses: [Business]) -> [Business] {
        let allBusinessessWithFavourites = allBusinesses.map { business -> Business in
            guard let favouriteBusiness = favBusinesses.first(where: { $0.id == business.id }) else { return business }
            var business = business
            business.isFavourite = favouriteBusiness.isFavourite
            return business
        }
        return allBusinessessWithFavourites
    }
}
