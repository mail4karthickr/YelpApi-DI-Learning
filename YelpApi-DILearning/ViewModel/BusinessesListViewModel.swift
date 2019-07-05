//
//  BusinessesListViewModel.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/30/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation
import RxSwift

class BusinessesListViewModel {
    private let businessGroupCareTaker: BusinessGroupCareTaker
    
    let businessesName: Observable<[Business]>
    let didSelectBusiness: Observable<Business>
    
    let selectBusiness: AnyObserver<Business>
    let markBusinessAsFavourite: AnyObserver<Business>
    
    typealias MakeBusinessGroupCareTakerFactory = () -> BusinessGroupCareTaker
    
    init(selectedCategory: String,
         ylpClient: YLPClient,
         businessGroupCareTaker: MakeBusinessGroupCareTakerFactory) {
        self.businessGroupCareTaker = businessGroupCareTaker()
        var searchQuery = SearchQuery(searchType: .location("SanFrancisco"))
        searchQuery.term = selectedCategory
        let res = ylpClient.search(with: searchQuery)
        
        businessesName = res.filter { $0.isSuccess }
            .map { $0.value! }
            .map { $0.adaptAllYLPBusiness() }
        
        let allYelpBusinesses = res.filter { $0.isSuccess }
            .map { $0.value! }
            .map { $0.adaptAllYLPBusiness() }
        
        let favouriteYelpBusinesses = self.businessGroupCareTaker.retrieveAllFavouriteBusinesses()
        
        res
            .filter { $0.isError }
            .map { $0.error! }
            .subscribe(onNext: { error in
                print("error ---- \(error)")
            })
        
        let _selectBusinessSubject = PublishSubject<Business>()
        selectBusiness = _selectBusinessSubject.asObserver()
        didSelectBusiness = _selectBusinessSubject.asObservable()
        
        let markBusinessAsFavouriteSubject = PublishSubject<Business>()
        markBusinessAsFavourite = markBusinessAsFavouriteSubject.asObserver()
        
        markBusinessAsFavouriteSubject
            .subscribe(onNext: { bus in
                print("bus --- \(bus)")
                do {
                    try self.businessGroupCareTaker.save(business: bus)
                } catch {
                    print("error --- \(error)")
                }
            })
    }
}
