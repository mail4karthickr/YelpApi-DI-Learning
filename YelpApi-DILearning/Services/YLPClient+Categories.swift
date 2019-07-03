//
//  YLPClient+Categories.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/29/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation
import RxSwift

extension YLPClient {
    func getAllCategories() -> Observable<Result<CategoriesGroup, YLPClientError>> {
        return Observable.create { observer in
            self.getModel(withPath: "/v3/categories",
                          successHandler: { (result: CategoriesGroup) in
                observer.onNext(.success(result))
            }, failureHandler: {
                observer.onNext(.error($0))
            })
            return Disposables.create()
        }
    }
    
    func getAllCategoriesJSON() {
        getJSON(withPath: "/v3/categories", successHandler: { json in
            print("json --- \(json)")
        }, failureHandler: { error in
            print("error --- \(error)")
        })
    }
}
