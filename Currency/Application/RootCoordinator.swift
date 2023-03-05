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
            let mainScreenController = mainScreenController()
            window?.rootViewController = mainScreenController
        }
    }
    
    private func mainScreenController() -> UIViewController {
        
        let mainScreenController = CurrencyConversionViewController()
        let navigationController = NavigationController(rootViewController: mainScreenController)
        let coordinator = CurrencyConversionCoordinator()
        
        let router = Router<CurrencyTarget>()
        let coreDataStack = CoreDataStack()
        let localDataSource = LocalDataSource<Conversion>(context: coreDataStack.context)
        
        let repository = CurrencyRepositoryImplementation(remoteService: router, localService: localDataSource)
        
        let convertUseCase = ConvertCurrencyUseCaseImplementation(repository: repository)
        let symbolsUseCase = CurrencySymbolsUseCaseImplementation(repository: repository)
        let viewModel = CurrencyConversionViewModel(coordinator: coordinator, currencySymbolsUseCase: symbolsUseCase, currencyConversionUseCase: convertUseCase)
        
        coordinator.viewController = mainScreenController
        mainScreenController.viewModel = viewModel
        return navigationController
    }
}

// MARK: - Define Screens
extension RootCoordinator {
    enum Screen {
        case mainScreen
    }
}
