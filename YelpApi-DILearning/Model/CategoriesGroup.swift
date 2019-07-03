//
//  Categories.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/29/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation

struct CategoriesGroup: Codable {
    var categories: [Categories]
    
    struct Categories: Codable {
        var alias: String?
        var title: String?
    }
}

extension CategoriesGroup {
    var allCategoryNames: [String] {
        return categories.map { $0.title ?? "" }
    }
}

