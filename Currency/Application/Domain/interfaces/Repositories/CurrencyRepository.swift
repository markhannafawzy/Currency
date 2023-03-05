//
//  CurrencyRepository.swift
//  Currency
//
//  Created by Mark Hanna on 04/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation
import RxSwift

protocol CurrencyRepository {
    func symbols() -> Observable<SymbolsResponse>
    func convert(to: String, from: String, amount: String) -> Observable<Conversion>
    func conversions() -> Observable<[Conversion]>
}
