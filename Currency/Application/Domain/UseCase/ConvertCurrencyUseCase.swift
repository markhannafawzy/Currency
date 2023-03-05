//
//  ConvertCurrencyUseCase.swift
//  Currency
//
//  Created by Mark Hanna on 05/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation
import RxSwift

protocol ConvertCurrencyUseCase {
    func execute(to: String, from: String, amount: String) -> Observable<Conversion>
}


final class ConvertCurrencyUseCaseImplementation: ConvertCurrencyUseCase {

    private let repository: CurrencyRepository

    init(repository: CurrencyRepository) {
        self.repository = repository
    }

    func execute(to: String, from: String, amount: String) -> Observable<Conversion> {
        return repository.convert(to: to, from: from, amount: amount)
    }
}
