//
//  Driver.swift
//  Currency
//
//  Created by Mark Hanna. on 12/19/18.
//  Copyright © 2018 Mark Hanna. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    func emptyDriverIfError() -> Driver<Element> {
        return asDriver { _ in return Driver<Element>.empty() }
    }

    func emptyObservableIfError() -> Observable<Element> {
        return catchError { _ in return Observable<Element>.empty() }
    }
}
