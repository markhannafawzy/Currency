//
//  HistoryViewModel.swift
//  Currency
//
//  Created by Mark Hanna on 05/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class HistoryViewModel: ViewModel {

    var coordinator: HistoryCoordinator?
    var allConversionsUseCase: AllConversionsUseCase
    
    init(coordinator: HistoryCoordinator, allConversionsUseCase: AllConversionsUseCase) {
        self.coordinator = coordinator
        self.allConversionsUseCase = allConversionsUseCase
    }

    func transform(input: Input) -> Output {
        let indicator: RxIndicator = RxIndicator()
        let rxError: RxError = RxError()
        let historyConversionViewModels: Driver<[HistoryConversionCellViewModel]> = input.loadTrigger
            .flatMapLatest { _ -> Driver<[Conversion]> in
                return self.allConversionsUseCase.execute().indicate(indicator).trackError(into: rxError).emptyDriverIfError()
            }
            .map { response -> [HistoryConversionCellViewModel] in
                return response.map { HistoryConversionCellViewModel(with: $0) }
            }
        
        let error = rxError.asObservable().do(onNext: { (error) in
            self.coordinator?.handleNetworkingError(error: error)
        }).emptyDriverIfError()
        
        let backButtonTapped: Driver<Void> = input.backButtonClicked
            .asObservable()
            .do(onNext: { [weak self] _ in
                self?.coordinator?.showScreen(.popup)
            })
            .emptyDriverIfError()
                
        let output = Output(historyConversionViewModels: historyConversionViewModels, indicator: indicator.asObservable().emptyDriverIfError(), error: error, backButtonTapped: backButtonTapped)
        return output
    }
}
// MARK: - Define
extension HistoryViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let backButtonClicked: Driver<Void>
    }

    struct Output {
        let historyConversionViewModels: Driver<[HistoryConversionCellViewModel]>
        let indicator: Driver<Bool>
        let error: Driver<Error>
        let backButtonTapped: Driver<Void>
    }
}
