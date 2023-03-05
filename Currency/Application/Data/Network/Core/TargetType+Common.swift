//
//  TargetType+Common.swift
//  Currency
//
//  Created by Mark Hanna on 02/09/2022.
//  Copyright © 2022 Mark Hanna. All rights reserved.
//

import Foundation
extension TargetType {

    var baseURL: URL {
        guard let url =  URL(string: server.baseUrl) else {
            fatalError("Incorrect Url")
        }
        return url
    }

    var headers: [String: String]? {
        return ["apikey": App.Key.FixerAPI.apiKey]
    }
}
