//
//  Coordinate.swift
//  Currency
//
//  Created by Mark Hanna. on 12/19/18.
//  Copyright © 2018 Mark Hanna. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinate {
    associatedtype Screen
    associatedtype View: UIViewController

    var viewController: View? { get set }

    func showScreen(_ screen: Screen)
    func showError(_ error: String)
}

// MARK: - Coordinator
extension Coordinate {
    func showError(_ error: String) {
        let okAction = ("ok", {  })
//        UIUtils.showDialog(title: "appName".localized, message: error,
//                           actions: [okAction], showCancel: false)
    }
    
    func handleNetworkingError(error: Error) {
        if let netWorkingError = error as? NetworkError {
            switch netWorkingError {
            case .network(let customMoyaNetworkingError):
                self.showError(customMoyaNetworkingError.getLocalizedDescription())
            case .json:
                self.showError("Error In Parsing JSON")
            case .offline:
                self.showError("No Internet Connection")
            case .other(let error):
                self.showError(error.localizedDescription)
            }
        } else {
            self.showError(error.localizedDescription)
        }
    }
}
