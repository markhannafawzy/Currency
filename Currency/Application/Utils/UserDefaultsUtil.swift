//
//  UserDefaultsUtil.swift
//
//  Created by Mark Hanna on 8/18/19.
//

import Foundation
import UIKit
import UserNotifications

class UserDefaultsUtil {
    
    static private let defaults = UserDefaults.standard
    
    static private let lang = "lang"
    
    class func setLang(language: String) {
        defaults.set(language, forKey: lang)
        defaults.set([language], forKey: "AppleLanguages")
        UIView.appearance().semanticContentAttribute = language == "ar" ?
                                                        .forceRightToLeft : .forceLeftToRight
    }
    
    class func getLang() -> String? {
        return defaults.string(forKey: lang)
    }
}
