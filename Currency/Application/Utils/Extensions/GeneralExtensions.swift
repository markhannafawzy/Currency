//
//  GeneralExtensions.swift
//  Currency
//
//  Created by Mark Hanna on 03/08/2022.
//  Copyright © 2022 Mark Hanna. All rights reserved.
//

import Foundation

extension Array {
    subscript(circular index: Int) -> Element? {
        guard index >= 0 && !isEmpty else { return nil }
        guard index >= count else { return self[index] }
        return self[index % count]
    }
}
