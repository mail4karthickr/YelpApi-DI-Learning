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
         businessMerger: BusinessMerger,
         businessGroupCareTaker: MakeBusinessGroupCareTakerFactory) {
        self.businessGroupCareTaker = businessGroupCareTaker()
        var searchQuery = SearchQuery(searchType: .location("SanFrancisco"))
        searchQuery.term = selectedCategory
        let res = ylpClient.search(with: searchQuery)
        
        let allYelpBusinesses = res.filter { $0.isSuccess }
            .map { $0.value! }
            .map { $0.adaptAllYLPBusiness() }
        
        let favouriteYelpBusinesses = self.businessGroupCareTaker.retrieveAllFavouriteBusinesses()
        
        businessesName = Observable.zip(favouriteYelpBusinesses, allYelpBusinesses).map { businessMerger.merge(favouriteBusinesses: $0, withAllBusinesses: $1) }
            .do(onNext: { ff in
                print("ff --- \(ff)")
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
                    var bus = bus
                    bus.isFavourite = !bus.isFavourite
                    try self.businessGroupCareTaker.save(business: bus)
                } catch {
                    print("error --- \(error)")
                }
            })
    }
}
