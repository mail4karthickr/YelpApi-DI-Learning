//
//  BusinessDetailsCoordinator.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/30/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation
import RxSwift

class BusinessesDetailsCoordinator: BaseCoordinator<Void> {
    typealias MakeBusinessDetailsViewModel = (Business) -> BusinessDetailsViewModel
    typealias MakeBusinessDetailsViewController = () -> BusinessDetailsViewController
    
    private var navigationController: UINavigationController
    private var makeBusinessDetailsViewController: MakeBusinessDetailsViewController
    private var makeBusinessDetailsViewModel: MakeBusinessDetailsViewModel
    private var business: Business
    
    init(navigationController: UINavigationController,
         business: Business,
         makeBusinessDetailsViewController: @escaping MakeBusinessDetailsViewController,
         makeBusinessDetailsViewModel: @escaping MakeBusinessDetailsViewModel) {
        self.navigationController = navigationController
        self.business = business
        self.makeBusinessDetailsViewController = makeBusinessDetailsViewController
        self.makeBusinessDetailsViewModel = makeBusinessDetailsViewModel
    }
    
    override func start() -> Observable<Void> {
        let viewModel =  makeBusinessDetailsViewModel(business)
        let viewController = makeBusinessDetailsViewController()
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
        
        viewModel
            .didSelectOpenMaps
            .subscribe(onNext: { self.openMaps(with: $0) })
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func openMaps(with coordinates: BusinessCoordinates) {
        let url = "http://maps.apple.com/maps?saddr=\(coordinates.latitude),\(coordinates.longitude)"
        UIApplication.shared.openURL(URL(string:url)!)
    }
}
