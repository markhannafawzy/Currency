//
//  CurrencyTarget.swift
//  Currency
//
//  Created by Mark Hanna on 04/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation
import Alamofire
enum CurrencyTarget {
    case symbols
    case convert(to: String, from: String, amount: String)
}

// MARK: - TargetType
extension CurrencyTarget: TargetType {
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .symbols:
            return .requestPlain
        case .convert(let to, let from, let amount):
            return .requestParameters(parameters: ["to": to, "from": from, "amount": amount], encoding: URLEncoding.queryString)
        }
    }
    
    var path: String {
        switch self {
        case .symbols:
            return "/symbols"
        case .convert(_, _, _):
            return "/convert"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .symbols:
            return .get
        case .convert(_, _, _):
            return .get
        }
    }
}
