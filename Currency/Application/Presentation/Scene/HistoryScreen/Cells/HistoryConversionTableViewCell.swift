//
//  HistoryConversionTableViewCell.swift
//  Currency
//
//  Created by Mark Hanna on 05/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import UIKit
class HistoryConversionTableViewCell: TableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    var viewModel: HistoryConversionCellViewModel! {
        didSet {
            guard viewModel != nil else { return }
            self.bind(self.viewModel)
        }
    }

    override func setupUI() {
        super.setupUI()
    }

    private func bind(_ viewModel: HistoryConversionCellViewModel) {
        date.text = viewModel.date
        amount.text = viewModel.amount
        
    }
}
