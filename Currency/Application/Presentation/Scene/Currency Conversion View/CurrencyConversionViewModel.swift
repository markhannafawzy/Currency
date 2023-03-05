//
//  CurrencyConversionViewModel.swift
//  Currency
//
//  Created by Mark Hanna on 05/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum CurrencyConversionScreenRequestType {
    case symbols
    case convert
}

enum SelectedAction {
    case fromSelection
    case toSelection
}

final class CurrencyConversionViewModel: ViewModel {

    var coordinator: CurrencyConversionCoordinator?

    var currencySymbolsUseCase: CurrencySymbolsUseCase?
    var currencyConversionUseCase: ConvertCurrencyUseCase?
    
    init(coordinator: CurrencyConversionCoordinator, currencySymbolsUseCase: CurrencySymbolsUseCase, currencyConversionUseCase: ConvertCurrencyUseCase) {
        self.coordinator = coordinator
        self.currencySymbolsUseCase = currencySymbolsUseCase
        self.currencyConversionUseCase = currencyConversionUseCase
    }

    func transform(input: Input) -> Output {
                        
        let detailsButtonTapped = input.detailsButtonTrigger.do { [weak self] _ in
            self?.coordinator?.showScreen(.history)
        }
        
        let indicator: RxIndicator = RxIndicator()
        let symbolsRxError: RxError = RxError()
        
        let symbols: Driver<[String]> = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<SymbolsResponse> in
                return self?.currencySymbolsUseCase?.execute().indicate(indicator).trackError(into: symbolsRxError).emptyDriverIfError() ?? Driver<SymbolsResponse>.empty()
            }.map { response in
                response.symbolsKeys
            }
        
        let symbolsLoaded: Driver<String> = symbols.compactMap { return $0.first }
        
        let symbolsDialogShown = input.symbolsTigger.withLatestFrom(symbols) {
            return $1
        }.do(onNext: { [weak self] lookupItems in
            self?.coordinator?.showScreen(.lookupsDialog(lookupItems: lookupItems))
        }).map { _ in return }
                
        let symbol: Driver<(title: String, selectedAction: SelectedAction)> = input.selectedSymbolViewModel.compactMap { [weak self] lookupViewModel in
            guard let symbolLookup = lookupViewModel.lookupItem as? String else { return nil }
            self?.coordinator?.showScreen(.dismissLookupsDialog)
            return symbolLookup.title
        }.withLatestFrom(input.symbolsTigger) {
            return (title: $0, selectedAction: $1)
        }
        
        let convertRxError: RxError = RxError()
        
        let conversionResult: Driver<ConversionResult> = input.convertTrigger.flatMapLatest { [weak self] query -> Driver<Conversion> in
            
            var fromSymbol: String = ""
            var toSymbol: String = ""
            
            switch query.selectedAction {
            case .fromSelection:
                fromSymbol = query.from
                toSymbol = query.to
            case .toSelection:
                fromSymbol = query.to
                toSymbol = query.from
            }
            return self?.currencyConversionUseCase?.execute(to: toSymbol, from: fromSymbol, amount: query.amount).indicate(indicator).trackError(into: convertRxError).emptyDriverIfError() ?? Driver<Conversion>.empty()
        }.withLatestFrom(input.convertTrigger) {
            return ConversionResult(resultAmount: "\($0.result ?? 0.0)", selectedAction: $1.selectedAction)
        }
        
        
        let symbolsError = symbolsRxError.asObservable().do(onNext:{ error in
            self.coordinator?.handleNetworkingError(error: error)
        }).map { return CurrencyConversionViewModel.ErrorItem(error: $0, requestType: .symbols) }
        
        let convertError = convertRxError.asObservable().do(onNext:{ error in
            self.coordinator?.handleNetworkingError(error: error)
        }).map { return CurrencyConversionViewModel.ErrorItem(error: $0, requestType: .convert) }
                
        let error = Observable.merge(symbolsError, convertError).emptyDriverIfError()
        
        let output = Output(symbolsLoaded: symbolsLoaded, symbolsDialogShown: symbolsDialogShown, symbol: symbol, conversioResult: conversionResult, detailsButtonTapped: detailsButtonTapped, indicator: indicator.asObservable().emptyDriverIfError(), error: error)
                
        return output
    }
}
// MARK: - Define
extension CurrencyConversionViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let detailsButtonTrigger: Driver<Void>
        let fromTFEditingChanged: Driver<String>
        let toTFEditingChanged: Driver<String>
        let symbolsTigger: Driver<SelectedAction>
        let selectedSymbolViewModel: Driver<LookupViewModel>
        let convertTrigger: Driver<ConvertQuery>
    }

    struct Output {
        let symbolsLoaded: Driver<String>
        let symbolsDialogShown: Driver<Void>
        let symbol: Driver<(title: String, selectedAction: SelectedAction)>
        let conversioResult: Driver<ConversionResult>
        let detailsButtonTapped: Driver<Void>
        let indicator: Driver<Bool>
        let error: Driver<ErrorItem>
    }
    
    struct ErrorItem {
        let error: Error
        let requestType :CurrencyConversionScreenRequestType
    }
}

struct ConversionResult {
    let resultAmount: String
    let selectedAction: SelectedAction
}
