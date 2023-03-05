//
//  TableViewCell.swift
//  Currency
//
//  Created by Mark Hanna. on 1/17/19.
//  Copyright © 2019 Mark Hanna. All rights reserved.
//

import UIKit
import RxSwift

class TableViewCell: UITableViewCell {

    var bag: DisposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    func setupUI() {}
    func bind() {}
}

class CollectionViewCell: UICollectionViewCell {

    var bag: DisposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    func setupUI() {}
}

class TableViewHeaderFooterView: UITableViewHeaderFooterView {

    var bag: DisposeBag = DisposeBag()

    override var reuseIdentifier: String? {
        return Self.identify
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    func setupUI() {}
}

class CollectionReusableView: UICollectionReusableView {

    var bag: DisposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    func setupUI() {}
}
