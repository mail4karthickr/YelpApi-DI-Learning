//
//  CategoriesListViewModel.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/29/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CategoriesListViewModel {
    let categoryNames: Observable<[String]>
    let error: Observable<String>
    let didSelectCategory: Observable<String>
    
    let selectCategory: AnyObserver<String>
    
    init(ylpClient: YLPClient, appSettings: AppSettings) {
        let result = ylpClient.getAllCategories()
        categoryNames = result
            .filter { $0.isSuccess }
            .filter { $0.value != nil }
            .map { $0.value! }
            .map { $0.allCategoryNames  }
        
        error = result
            .filter { $0.isError }
            .map { $0.error ?? .unknownError }
            .map { $0.localizedDescription }
        
        let _selectCategory = PublishSubject<String>()
        selectCategory = _selectCategory.asObserver()
        didSelectCategory = _selectCategory.asObservable()
    }
}
