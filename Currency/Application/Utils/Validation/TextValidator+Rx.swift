//
//  TextValidator+Rx.swift
//  Currency
//
//  Created by Mark Hanna on 15/07/2022.
//  Copyright © 2022 Mark Hanna. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
extension TextValidator {
    func validate(editingChangedEvent: Driver<String>, validationType:TextValidationType) -> Driver<ValidationResult> {
        return editingChangedEvent.map { [weak self] text -> ValidationResult in
            guard let `self` = self else { return (false,"") }
            self.validationType = validationType
            let validationResult = self.validate(text: text)
            return validationResult
        }
    }
}
