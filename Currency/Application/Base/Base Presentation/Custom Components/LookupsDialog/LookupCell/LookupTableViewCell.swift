//
//  LookupTableViewCell.swift
//  Currency
//
//  Created by Mark Hanna on 11/01/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import UIKit

class LookupTableViewCell: BaseDialogCell<LookupViewModel> {

    @IBOutlet weak var titleLabel: UILabel!

    override var viewModel: LookupViewModel! {
        didSet {
            guard viewModel != nil else { return }
            self.bind(self.viewModel)
        }
    }

    override func setupUI() {
        super.setupUI()
    }

    override func bind(_ viewModel: LookupViewModel) {
        titleLabel.text = viewModel.title
    }
}
