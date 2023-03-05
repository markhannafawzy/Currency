//
//  CurrencyConversionCoordinator.swift
//  Currency
//
//  Created by Mark Hanna on 05/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
final class CurrencyConversionCoordinator: Coordinate {
    weak var viewController: CurrencyConversionViewController?

    
    func showScreen(_ screen: CurrencyConversionCoordinator.Screen) {
        switch screen {
        case .history:
            viewController?.navigationController?.pushViewController(historyScreenController(), animated: true, completion: nil)
            break
        case .lookupsDialog(lookupItems: let lookupItems):
            guard let vc = self.viewController else { break }
            let lookupsDialog = vc.view.showLookupsDialog(title: "Currencies", lookupItems: lookupItems) as LookupsDialog<LookupTableViewCell, LookupViewModel, LookupItemProtocol>
            lookupsDialog.tableView.rx.modelSelected(LookupViewModel.self).bind(to: vc.selectedSymbol).disposed(by: lookupsDialog.disposeBag ?? DisposeBag())
        case .dismissLookupsDialog:
            guard let _ = self.viewController?.view.hideLookupsDialog() as? LookupsDialog<LookupTableViewCell, LookupViewModel, LookupItemProtocol> else { break }
        }
    }
    
    
    private func historyScreenController() -> UIViewController {
        
        let historyScreenController = HistoryViewController()
        let coordinator = HistoryCoordinator()
        
        let router = Router<CurrencyTarget>()
        let coreDataStack = CoreDataStack()
        let localDataSource = LocalDataSource<Conversion>(context: coreDataStack.context)
        
        let repository = CurrencyRepositoryImplementation(remoteService: router, localService: localDataSource)
        
        let allConversionsUseCase = AllConversionsUseCaseImplementation(repository: repository)
        
        let viewModel = HistoryViewModel(coordinator: coordinator, allConversionsUseCase: allConversionsUseCase)
        
        coordinator.viewController = historyScreenController
        historyScreenController.viewModel = viewModel
        return historyScreenController
    }
}

// MARK: - Screen
extension CurrencyConversionCoordinator {
    enum Screen {
        case history
        case lookupsDialog(lookupItems:[String])
        case dismissLookupsDialog
    }
}
