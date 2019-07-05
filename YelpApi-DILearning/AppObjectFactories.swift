//
//  AppObjectFactories.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/30/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import UIKit

class AppObjectFactories {
    func makeAppCoordinator(window: UIWindow) -> AppCoordinator {
        let categoriesListCoordinator = makeCategoriesListCoordinator(window: window)
        return AppCoordinator(categoriesListCoordinator: categoriesListCoordinator)
    }
    
    // MARK: - Categories Listing
    
    func makeCategoriesListCoordinator(window: UIWindow) -> CategoriesListCoordinator {
        
        let businessListCoordinator: (_ navigationController: UINavigationController, _ selectedCategory: String) -> BusinessesListCoordinator = {
                return self.makeBusinessListCoordinator(navigationController: $0, categoryName: $1)
        }
        
        return CategoriesListCoordinator(window: window,
                                  categoriesListViewModel: makeCategoriesListViewModel(),
                                  categoriesListViewController: makeCategoriesListViewController(),
                                  makeBusinessListCoordinator: businessListCoordinator)
    }
    
    func makeCategoriesListViewModel() -> CategoriesListViewModel {
        return CategoriesListViewModel(ylpClient: makeYLPClient())
    }
    
    func makeCategoriesListViewController() -> CategoriesListViewController {
        return CategoriesListViewController.initFromStoryboard(name: "CategoriesListing")
    }
    
    // MARK: - Businesses Listing
    
    func makeBusinessListCoordinator(navigationController: UINavigationController,
                                     categoryName: String) -> BusinessesListCoordinator {
        
        let businessDetailsCoordinator: (UINavigationController, Business) -> BusinessesDetailsCoordinator = {
            return self.makeBusinessDetailsCoordinator(navigationController: $0, business: $1)
        }
        
        let businessListCoordinator = BusinessesListCoordinator(navigationController: navigationController,
                                                                selectedCategory: categoryName,
                                                                makeBusinessListViewModel: makeBusinessListViewModel,
                                                                businessListViewController: makeBusinessListViewController(),
                                                                makeBusinessDetailsCoordinator: businessDetailsCoordinator)
        return businessListCoordinator
    }
    
    func makeBusinessListViewController() -> BusinessesListViewController {
        return BusinessesListViewController.initFromStoryboard(name: "BusinessesList")
    }
    
    func makeBusinessListViewModel(categoryName: String) -> BusinessesListViewModel {
        let makeBusinessGroupCareTakerFactory = {
            return self.makeBusinessGroupCareTaker(diskCareTaker: self.makeDiskCareTaker())
        }
        return BusinessesListViewModel(selectedCategory: categoryName,
                                       ylpClient: makeYLPClient(),
                                       businessMerger: BusinessMerger(), 
                                businessGroupCareTaker: makeBusinessGroupCareTakerFactory)
    }
    
    // MARK: - Business details listing
    
    func makeBusinessDetailsCoordinator(navigationController: UINavigationController,
                                        business: Business) -> BusinessesDetailsCoordinator {
        
        let businessDetailsViewController: () -> BusinessDetailsViewController = {
            self.makeBusinessDetailsViewController()
        }
        
        let businessDetailsViewModel: (Business) -> BusinessDetailsViewModel = {
            self.makeBusinessDetailsViewModel(business: $0)
        }
        
        return BusinessesDetailsCoordinator(navigationController: navigationController,
            business: business,
            makeBusinessDetailsViewController: businessDetailsViewController,
            makeBusinessDetailsViewModel: businessDetailsViewModel)
    }
    
    func makeBusinessDetailsViewController() -> BusinessDetailsViewController {
        return BusinessDetailsViewController.initFromStoryboard(name: "BusinessDetails")
    }
    
    func makeBusinessDetailsViewModel(business: Business) -> BusinessDetailsViewModel {
        return BusinessDetailsViewModel(business: business)
    }
    
    // MARK: - Common
    func makeYLPClient() -> YLPClient {
        return YLPClient()
    }
    
    func makeDiskCareTaker() -> DiskCareTaker {
        return DiskCareTaker()
    }
    
    func makeBusinessGroupCareTaker(diskCareTaker: DiskCareTaker) -> BusinessGroupCareTaker {
        return BusinessGroupCareTaker(diskCareTaker: diskCareTaker)
    }
}
