//
//  TextValidator.swift
//
//  Created by Mark Hanna on 7/17/19.
//

import Foundation

typealias ValidationResult = (isValid: Bool, errorMessage: String?)

class TextValidator {
    
    var validationType: TextValidationType!

    required init(validationType: TextValidationType) {
        self.validationType = validationType
    }
    
    func validate(text: String) -> ValidationResult {
        
        for (indx, regex) in validationType.values.regexArray.enumerated() {
            
            if !text.matches(regex.rawValue, input: text) {
                return (false, validationType.values.errorMessages[indx])
            }
        }
        
        return (true, nil)
    }
}
