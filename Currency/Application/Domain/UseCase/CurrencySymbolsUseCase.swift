//
//  CurrencySymbolsUseCase.swift
//  Currency
//
//  Created by Mark Hanna on 05/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation
import RxSwift

protocol CurrencySymbolsUseCase {
    func execute() -> Observable<SymbolsResponse>
}


final class CurrencySymbolsUseCaseImplementation: CurrencySymbolsUseCase {

    private let repository: CurrencyRepository

    init(repository: CurrencyRepository) {
        self.repository = repository
    }

    func execute() -> Observable<SymbolsResponse> {
        return repository.symbols()
    }
}
