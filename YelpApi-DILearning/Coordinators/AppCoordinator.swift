//
//  AppCoordinator.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/30/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    private let categoriesListCoordinator: CategoriesListCoordinator
    
    init(categoriesListCoordinator: CategoriesListCoordinator) {
        self.categoriesListCoordinator = categoriesListCoordinator
    }
    
    override func start() -> Observable<Void> {
        return coordinate(to: categoriesListCoordinator)
    }
}
