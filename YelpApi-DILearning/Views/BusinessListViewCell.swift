//
//  BusinessListViewCell.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 7/4/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import UIKit
import RxSwift

public class BusinessListViewCell: UITableViewCell {
    @IBOutlet var favouriteButton: UIButton!
    var disposeBag = DisposeBag()
}
