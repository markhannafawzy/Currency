//
//  SymbolsResponse.swift
//  Currency
//
//  Created by Mark Hanna on 04/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation

// MARK: - SymbolsResponse
struct SymbolsResponse: Codable {
    var success: Bool?
    var symbols: [String: String]?
    
    var symbolsKeys: [String] {
        guard let symbols = symbols else {
            return []
        }
        return Array(symbols.keys)
    }
}
