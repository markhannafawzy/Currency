//
//  UITableViewCell.swift
//  Currency
//
//  Created by Mark Hanna. on 2/1/19.
//  Copyright © 2019 Mark Hanna. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var identify: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var identify: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    static var identify: String {
        return String(describing: self)
    }
}
