//
//  RxError.swift
//  Currency
//
//  Created by Mark Hanna. on 12/19/18.
//  Copyright © 2018 Mark Hanna. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class RxError: ObservableConvertibleType {
    private let _subject = PublishSubject<Error>()

    deinit {
        _subject.onCompleted()
    }

    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }

    fileprivate func track<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: { error in
            self._subject.onNext(error)
        })
    }
}

// MARK: - ObservableConvertibleType
extension ObservableConvertibleType {
    func trackError(into error: RxError) -> Observable<Element> {
        return error.track(from: self)
    }
}
