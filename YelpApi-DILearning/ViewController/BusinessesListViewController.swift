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
        
       let allBusinesses = BusinessGroupCareTaker(diskCareTaker: DiskCareTaker()).retrieveAllFavouriteBusinesses()
        allBusinesses
            .subscribe(onNext: { bus in
                print("\(bus.map { $0.name! })")
            })

        viewModel.businessesName.bind(to: tableView.rx.items(cellIdentifier: "BusinessNameCell", cellType: BusinessListViewCell.self)) { row, element, cell in
            cell.textLabel?.text = element.name ?? "unknown"
            cell.favouriteButton
                .rx
                .tap
                .asObservable()
                .map { element }
                .bind(to: self.viewModel.markBusinessAsFavourite)
                .disposed(by: cell.disposeBag)
            
            let image = element.isFavourite ? UIImage(imageLiteralResourceName: "favouriteSelected") : UIImage(imageLiteralResourceName: "favouriteUnselected")
            cell.favouriteButton.setImage(image, for: .normal)
            }
            .disposed(by: disposeBag)
        
        
        
        tableView
            .rx
            .modelSelected(Business.self)
            .bind(to: viewModel.selectBusiness)
            .disposed(by: disposeBag)
    }
}
