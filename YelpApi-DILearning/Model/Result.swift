//
//  Result.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/28/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation

public enum Result<Value, E: Error> {
    case success(Value)
    case error(E)
    
    var value: Value? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }
    
    var error: E? {
        switch self {
        case .error(let error):
            return error
        default:
            return nil
        }
    }
    
    var isSuccess: Bool {
        switch self {
        case .success(_):
            return true
        default:
            return false
        }
    }
    
    var isError: Bool {
        switch self {
        case .error(_):
            return true
        default:
            return false
        }
    }
}
