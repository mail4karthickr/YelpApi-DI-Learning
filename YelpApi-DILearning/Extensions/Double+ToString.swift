//
//  Double+ToString.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/28/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation

extension Double {
    public func toString() -> String {
        return String(format: "%f", self)
    }
}
