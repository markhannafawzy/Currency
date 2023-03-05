//
//  Conversion.swift
//  Currency
//
//  Created by Mark Hanna on 04/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation

// MARK: - Conversion
struct Conversion: Codable {
    var date: String?
    var info: Info?
    var query: Query?
    var result: Double?
    var success: Bool?
    
    
    init(to: String, from: String, timestamp: Int, amount: Double, result: Double) {
        let dateObject = Date(timeIntervalSince1970: Double(timestamp))
        let dateString = DateUtils.convertDateToStr(date: dateObject, targetFormat: DateFormat.datePartReversed.rawValue)
        date = dateString
        info = Info(rate: result, timestamp: timestamp)
        query = Query(amount: amount, from: from, to: to)
    }
}

// MARK: - Info
struct Info: Codable {
    var rate: Double?
    var timestamp: Int?
}

// MARK: - Query
struct Query: Codable {
    var amount: Double?
    var from, to: String?
}
