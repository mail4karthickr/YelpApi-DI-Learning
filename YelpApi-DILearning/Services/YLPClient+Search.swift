//
//  YLPClient+Search.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/28/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation
import RxSwift

extension YLPClient {
    func search(with query: SearchQuery) -> Observable<Result<YelpBusinessesGroup, YLPClientError>> {
        return Observable.create { observer in
            self.getModel(withPath: "/v3/businesses/search",
                     params: query.parameters,
                     successHandler: { (result: YelpBusinessesGroup) in
                observer.onNext(.success(result))
            }, failureHandler: {
                observer.onNext(.error($0))
            })
            return Disposables.create()
        }
    }
}
