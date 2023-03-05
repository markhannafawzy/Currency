//
//  LookupViewModel.swift
//  Currency
//
//  Created by Mark Hanna on 11/01/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation

final class LookupViewModel: BaseDialogViewModel<LookupItemProtocol> {

    var title: String!

    required init(lookupItem: LookupItemProtocol) {
        super.init(lookupItem: lookupItem)
        self.title = lookupItem.title
    }
}

protocol LookupItemProtocol {
    var id: Int { get }
    var title: String { get }
}

// MARK: - LookupItem
struct LookupItem: Codable {
    let id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "TITLE"
    }
}
extension LookupItem: LookupItemProtocol {}
