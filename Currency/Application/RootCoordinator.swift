//
//  RootCoordinator.swift
//  Currency
//
//  Created by Mark Hanna. on 1/16/19.
//  Copyright © 2019 Mark Hanna. All rights reserved.
//

import UIKit

final class RootCoordinator: Coordinate {

    weak var viewController: UIViewController?
    weak var window: UIWindow? {
        didSet {
            viewController = window?.rootViewController
        }
    }

    func showScreen(_ screen: Screen) {
        switch screen {
        case .mainScreen:
            let splashViewController = mainScreenController()
            window?.rootViewController = splashViewController
        }
    }
    
    private func mainScreenController() -> UIViewController {
        return UIViewController()
    }
}

// MARK: - Define Screens
extension RootCoordinator {
    enum Screen {
        case mainScreen
    }
}
