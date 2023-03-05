//
//  HistoryConversionCellViewModel.swift
//  Currency
//
//  Created by Mark Hanna on 05/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation

final class HistoryConversionCellViewModel {
    let date: String
    let amount: String

    
    init(with conversion: Conversion) {
        self.date = conversion.date ?? ""
        self.amount = "\(conversion.query?.amount ?? 0.0)"
    }
}
