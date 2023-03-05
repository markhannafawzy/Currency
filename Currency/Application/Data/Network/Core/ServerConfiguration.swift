//
//  ServerConfiguration.swift
//  Currency
//
//  Created by Mark Hanna on 02/09/2022.
//  Copyright © 2022 Mark Hanna. All rights reserved.
//

import Foundation

enum Server {
    case developement
    case staging
    case production
    
    var baseUrl: String {
        switch self {
        case .developement:
            return "https://api.apilayer.com/fixer"
        case .staging:
            return "https://api.apilayer.com/fixer"
        case .production:
            return "https://api.apilayer.com/fixer"
        }
    }
}

let server: Server = .developement
