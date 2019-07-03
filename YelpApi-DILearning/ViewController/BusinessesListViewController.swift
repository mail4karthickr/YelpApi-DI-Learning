//
//  BusinessesListViewController.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/30/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import UIKit
import RxSwift

class BusinessesListViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    var viewModel: BusinessesListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.businessesName.bind(to: tableView.rx.items(cellIdentifier: "BusinessNameCell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = element.name ?? "unknown"
            }
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(BusinessesGroup.Business.self)
            .bind(to: viewModel.selectBusiness)
            .disposed(by: disposeBag)
    }
}
