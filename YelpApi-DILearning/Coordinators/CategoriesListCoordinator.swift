//
//  CategoriesListingCoordinator.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/29/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import UIKit
import RxSwift

class CategoriesListCoordinator: BaseCoordinator<Void> {
    private var window: UIWindow
    private var categoriesListViewModel: CategoriesListViewModel
    private var categoriesListViewController: CategoriesListViewController
    private var makeBusinessListCoordinator: (UINavigationController, String) -> BusinessesListCoordinator
    
    init(window: UIWindow,
         categoriesListViewModel: CategoriesListViewModel,
         categoriesListViewController: CategoriesListViewController,
         makeBusinessListCoordinator: @escaping (UINavigationController, String) -> BusinessesListCoordinator) {
        self.window = window
        self.categoriesListViewModel = categoriesListViewModel
        self.categoriesListViewController = categoriesListViewController
        self.makeBusinessListCoordinator = makeBusinessListCoordinator
    }
    
    override func start() -> Observable<Void> {
        let navigationController = UINavigationController(rootViewController: categoriesListViewController)
        categoriesListViewController.viewModel = categoriesListViewModel
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        categoriesListViewModel
            .didSelectCategory
            .subscribe(onNext: { sel in
                self.pushBusinessList(on: navigationController, selectedCategory: sel)
            })
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func pushBusinessList(on navigationController: UINavigationController, selectedCategory: String) {
        let businessListCoordinator = makeBusinessListCoordinator(navigationController, selectedCategory)
        _ = coordinate(to: businessListCoordinator)
    }
}
