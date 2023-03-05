//
//  HistoryCoordinator.swift
//  Currency
//
//  Created by Mark Hanna on 05/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation
import UIKit
final class HistoryCoordinator: Coordinate {
    weak var viewController: HistoryViewController?

    func showScreen(_ screen: HistoryCoordinator.Screen) {
        switch screen {
        case .popup:
            self.viewController?.navigationController?.popViewController(animated: true)
            break
        }
    }
}

// MARK: - Screen
extension HistoryCoordinator {
    enum Screen {
        case popup
    }
}
