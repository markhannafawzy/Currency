//
//  TextValidationType.swift
//  HealthLink
//
//  Created by Mark Hanna on 8/20/19.
//  Copyright © 2019 saragn. All rights reserved.
//

import Foundation

enum TextValidationType {
    
    case numberRegex
    case decimalRegex
    case notEmpty
    
    var values: (regexArray: [RegexString], errorMessages: [String]) {
        
        switch self {
            
        case .notEmpty: return ([.notEmpty], ["not_empty".localized])
        case .numberRegex: return ([.notEmpty, .numberRegex], ["not_empty".localized, ""])
        case .decimalRegex: return ([.notEmpty, .decimalRegex], ["not_empty".localized, ""])
        
        }
    }
    
    public enum RegexString: String {
        case notEmpty = "^(?!s*$).+"
        case notZero = "[^0]"
        case numberRegex = "^[0-9٠-٩ ]{1,}$"
        case decimalRegex = "^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$"
    }
    
}
