//
//  RxIndicator.swift
//  Currency
//
//  Created by Mark Hanna. on 12/19/18.
//  Copyright © 2018 Mark Hanna. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SVProgressHUD

final class RxIndicator: ObservableConvertibleType {
    private let _relay = BehaviorRelay(value: false)
    private let _loading: Observable<Bool>

    init() {
        _loading = _relay.distinctUntilChanged()
    }

    func asObservable() -> Observable<Bool> {
        return _loading.asObservable()
    }

    fileprivate func track<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        return source.asObservable()
            .do(onNext: { _ in
                self.dismiss()
            }, onError: { _ in
                self.dismiss()
            }, onCompleted: {
                self.dismiss()
            }, onSubscribe: {
                self.show()
            },onDispose: {
                self.dismiss()
            })
    }

    private func show() {
        _relay.accept(true)
        SVProgressHUD.show()
    }

    private func dismiss() {
        _relay.accept(false)
        SVProgressHUD.popActivity()
    }
}

// MARK: - ObservableConvertibleType
extension ObservableConvertibleType {
    func indicate(_ indicator: RxIndicator) -> Observable<Element> {
        return indicator.track(self)
    }
}
