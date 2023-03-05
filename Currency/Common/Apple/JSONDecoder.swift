//
//  JSONDecoder.swift
//  Currency
//
//  Created by Mark Hanna. on 12/17/18.
//  Copyright © 2018 Mark Hanna. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static let shared: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
        return decoder
    }()
}
