//
//  CategoriesListViewController.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/29/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CategoriesListViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var viewModel: CategoriesListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .categoryNames
            .bind(to: tableView.rx.items(cellIdentifier: "CategoriesListingCell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = element
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .bind(to: viewModel.selectCategory)
            .disposed(by: disposeBag)
    }
}
