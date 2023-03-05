//
//  RxExtension.swift
//  Currency
//
//  Created by Mark Hanna. on 4/5/19.
//  Copyright © 2019 Mark Hanna. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension SharedSequence {
    public func unwrap<T>() -> SharedSequence<SharingStrategy, T> where Element == T? {
        return self.filter { $0 != nil }.map({ (value) -> T in
            guard let value = value else { fatalError() }
            return value
        })
    }
}
