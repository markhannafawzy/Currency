//
//  NavigationController.swift
//  Currency
//
//  Created by Mark Hanna. on 1/16/19.
//  Copyright © 2019 Mark Hanna. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController {
    
    weak var progress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

    }
    
    func setupUI() {
    }
}
