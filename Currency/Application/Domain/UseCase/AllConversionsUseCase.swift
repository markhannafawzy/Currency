//
//  AllConversionsUseCase.swift
//  Currency
//
//  Created by Mark Hanna on 05/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation
import RxSwift

protocol AllConversionsUseCase {
    func execute() -> Observable<[Conversion]>
}


final class AllConversionsUseCaseImplementation: AllConversionsUseCase {

    private let repository: CurrencyRepository

    init(repository: CurrencyRepository) {
        self.repository = repository
    }

    func execute() -> Observable<[Conversion]> {
        return repository.conversions()
    }
}
