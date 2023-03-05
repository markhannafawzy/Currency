//
//  DateFormatter.swift
//  Currency
//
//  Created by Mark Hanna. on 12/17/18.
//  Copyright © 2018 Mark Hanna. All rights reserved.
//

import Foundation

// MARK: - Mapping For Date
extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()

    static let hour: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
}
