//
//  BusinessDetailsViewModel.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/30/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation
import RxSwift

class BusinessDetailsViewModel {
    let businessName: Observable<String>
    let businessAddress: Observable<String>
    let businessCoordinates: Observable<BusinessCoordinates?>
    let didSelectOpenMaps: Observable<BusinessCoordinates>
    
    let selectOpenMaps: AnyObserver<BusinessCoordinates>
    
    init(business: Business) {
        businessName = .just(business.name ?? "")
        businessAddress = .just("")
        businessCoordinates = .just(business.coordinates)
        
        let openMapsSubject = PublishSubject<BusinessCoordinates>()
        selectOpenMaps = openMapsSubject.asObserver()
        didSelectOpenMaps = openMapsSubject.asObservable()
    }
}
