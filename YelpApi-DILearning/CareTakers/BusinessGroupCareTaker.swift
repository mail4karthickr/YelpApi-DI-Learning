//
//  BusinessGroupCareTaker.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 7/4/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation
import RxSwift

enum BusinessGroupCareTakerError: Error {
    case documentsDirectoryIsEmpty
}

public final class BusinessGroupCareTaker {
    private var diskCareTaker: DiskCareTaker
    
    init(diskCareTaker: DiskCareTaker) {
        self.diskCareTaker = diskCareTaker
    }
    
    func retrieveAllFavouriteBusinesses() -> Observable<[Business]> {
        return Observable.create { observer in
            guard let urls = try? self.diskCareTaker.contentsOfDocumentDirectory() else {
                observer.onError(BusinessGroupCareTakerError.documentsDirectoryIsEmpty)
                return Disposables.create()
            }
            if let businesses = try? urls.map { try self.diskCareTaker.retrieve(type: Business.self, fromURL: $0) } {
                observer.onNext(businesses)
                return Disposables.create()
            } else {
                observer.onNext([])
                return Disposables.create()
            }
        }
    }
    
    
    func save(business: Business) throws {
        guard let businessId = business.id else {
            return
        }
        
        try DiskCareTaker().save(object: business, fileName: businessId)
    }
}
