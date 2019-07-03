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
    let businessesName: Observable<[BusinessesGroup.Business]>
    let didSelectBusiness: Observable<BusinessesGroup.Business>
    
    let selectBusiness: AnyObserver<BusinessesGroup.Business>
    
    init(selectedCategory: String, ylpClient: YLPClient, appSettings: AppSettings) {
        var searchQuery = SearchQuery(searchType: .location("SanFrancisco"))
        searchQuery.term = selectedCategory
        let res = ylpClient.search(with: searchQuery)
        
        businessesName = res.filter { $0.isSuccess }
            .map { $0.value! }
            .map { $0.businesses }
        
        res
            .filter { $0.isError }
            .map { $0.error! }
            .subscribe(onNext: { error in
                print("error ---- \(error)")
            })
        
        let _selectBusinessSubject = PublishSubject<BusinessesGroup.Business>()
        selectBusiness = _selectBusinessSubject.asObserver()
        didSelectBusiness = _selectBusinessSubject.asObservable()
    }
}
