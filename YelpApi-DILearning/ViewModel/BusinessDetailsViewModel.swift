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
    typealias Coordinates = BusinessesGroup.Business.Coordinates
    let businessName: Observable<String>
    let businessAddress: Observable<String>
    let businessCoordinates: Observable<Coordinates>
    let didSelectOpenMaps: Observable<Coordinates>
    
    let selectOpenMaps: AnyObserver<Coordinates>
    
    init(business: BusinessesGroup.Business, appSettings: AppSettings) {
        businessName = .just(business.name ?? "")
        businessAddress = .just(business.location.address1 ?? "")
        businessCoordinates = .just(business.coordinates)
        
        let openMapsSubject = PublishSubject<Coordinates>()
        selectOpenMaps = openMapsSubject.asObserver()
        didSelectOpenMaps = openMapsSubject.asObservable()
    }
}
