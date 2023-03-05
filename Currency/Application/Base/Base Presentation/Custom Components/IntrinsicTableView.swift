//
//  IntrinsicTableView.swift
//
//  Created by Mark Hanna on 12/11/18.
//

import UIKit

class IntrinsicTableView: UITableView {

    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
}

class AutomaticIntrinsicTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
//        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}

