//
//  Query.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/28/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation
import CoreLocation

struct SearchQuery {
    var searchType: SearchType
    
    var term: String?
    var price: String?
    var locale: String?
    var limit: Int?
    var openAt: Int?
    var openNow: Bool?
    var offset: Int?
    var sortType: SortType?
    var categoryFilter: [String] = []
    var radiusFilter: Double?
    var dealsFilter: Bool?
    var hotAndNewFilter: Bool?
    
    init(searchType: SearchType) {
        self.searchType = searchType
    }
    
    var parameters: [String: String] {
        var params: [String: String] = [:]
        switch searchType {
        case .coordinate(let coordinate):
            params["latitude"] = coordinate.latitude.toString()
            params["longitude"] = coordinate.longitude.toString()
        case .location(let location):
            params["location"] = location
        }
        
        if let term = term {
            params["term"] = term
        }
        if let price = price {
            params["price"] = price
        }
        if let locale = locale {
            params["locale"] = locale
        }
        if let limit = limit {
            params["limit"] = limit.toString()
        }
        if let openAt = openAt {
            params["openAt"] = openAt.toString()
        }
        if let offset = offset {
            params["offset"] = offset.toString()
        }
        if let sortType = sortType {
            params["sort_by"] = sortType.rawValue
        }
        if categoryFilter.count > 0 {
            params["categories"] = categoryFilter.joined(separator: ",")
        }
        if let radiusFilter = radiusFilter,
            radiusFilter > 0 {
            params["radius"] = radiusFilter.toString()
        }
        if let _ = dealsFilter,
            let _ = hotAndNewFilter {
             params["attributes"] = "deals,hot_and_new"
        }
        if let _ = dealsFilter {
            params["attributes"] = "deals"
        }
        if let _ = hotAndNewFilter {
            params["attributes"] = "hot_and_new"
        }
        if let _ = openNow,
            let openAt = openAt,
            openAt == 0 {
            params["open_now"] = "true"
        }
        
        return params
    }
}

enum SearchType {
    case location(String)
    case coordinate(CLLocationCoordinate2D)
}

enum SortType: String {
    case bestMatched = "best_matched"
    case distance = "distance"
    case highestRated = "rating"
    case mostReviewed = "review_count"
}
