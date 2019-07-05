//
//  BusinessesListCoordinator.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/30/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation
import RxSwift

class BusinessesListCoordinator: BaseCoordinator<Void> {
    typealias MakeBusinessDetailsCoordinator = (UINavigationController, Business) -> BusinessesDetailsCoordinator
    typealias MakeBusinessListViewModel = (String) -> BusinessesListViewModel
    
    private var navigationController: UINavigationController
    private var selectedCategoty: String
    private var businessListViewController: BusinessesListViewController
    private var makeBusinessListViewModel: MakeBusinessListViewModel
    private var makeBusinessDetailsCoordinator: MakeBusinessDetailsCoordinator
    
    init(navigationController: UINavigationController,
         selectedCategory: String,
         makeBusinessListViewModel: @escaping MakeBusinessListViewModel,
         businessListViewController: BusinessesListViewController,
         makeBusinessDetailsCoordinator: @escaping MakeBusinessDetailsCoordinator) {
        self.navigationController = navigationController
        self.selectedCategoty = selectedCategory
        self.businessListViewController = businessListViewController
        self.makeBusinessListViewModel = makeBusinessListViewModel
        self.makeBusinessDetailsCoordinator = makeBusinessDetailsCoordinator
    }
    
    override func start() -> Observable<Void> {
        let viewModel = makeBusinessListViewModel(selectedCategoty)
        businessListViewController.viewModel = viewModel
        
        navigationController.pushViewController(businessListViewController, animated: true)
        
        viewModel
            .didSelectBusiness
            .subscribe(onNext: {
                self.pushBusinessDetails(on: self.navigationController, selectedBusiness: $0)
            })
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func pushBusinessDetails(on navigationController: UINavigationController, selectedBusiness: Business) {
        let businessDetailsCoordinator = makeBusinessDetailsCoordinator(navigationController, selectedBusiness)
        _ = coordinate(to: businessDetailsCoordinator)
    }
}
