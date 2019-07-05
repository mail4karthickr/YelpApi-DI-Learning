//
//  RestaurantsListViewController.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/29/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import UIKit
import RxSwift

class BusinessDetailsViewController: UIViewController, StoryboardInitializable {
    var viewModel: BusinessDetailsViewModel!
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    @IBOutlet weak var openMaps: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .businessName
            .bind(to: businessName.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .businessAddress
            .bind(to: businessAddress.rx.text)
            .disposed(by: disposeBag)
        
        Observable.zip(openMaps.rx.tap.asObservable(), viewModel.businessCoordinates)
            .filter { $0.1 != nil }
            .map { $0.1! }
            .bind(to: viewModel.selectOpenMaps)
            .disposed(by: disposeBag)
    }
}
