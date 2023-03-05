//
//  LookupsCoordinator.swift
//  Currency
//
//  Created by Mark Hanna on 03/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation
import UIKit
final class LookupsCoordinator: Coordinate {
    weak var viewController: UIViewController?

    func showScreen(_ screen: LookupsCoordinator.Screen) {
        switch screen {
        case .popup:
            self.viewController?.navigationController?.popViewController(animated: true)
            break
        }
    }
}

// MARK: - Screen
extension LookupsCoordinator {
    enum Screen {
        case popup
    }
}
