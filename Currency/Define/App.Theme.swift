//
//  Theme.swift
//  Currency
//
//  Created by Mark Hanna. on 12/18/18.
//  Copyright © 2018 Mark Hanna. All rights reserved.
//

import UIKit

protocol ColorPackage {
    var tabbarBackground: UIColor { get }
    var tabbarText: UIColor { get }
    var tabbarTint: UIColor { get }
    var unselectedTabbarTint: UIColor { get }
    var viewBackground: UIColor { get }
    var pageIndicatorTintColor: UIColor { get }
    var currentPageIndicatorCurrentColor: UIColor { get }
    var textFieldSelectedBorder: UIColor { get }
    var textFieldNotSelectedBorder: UIColor { get }
    var buttonBackgroundColor: UIColor { get }
    var dialogButtonColor: UIColor { get }
    var tabActiveColor: UIColor { get }
    var tabInActiveColor: UIColor { get }
    var grayUnderLineColor: UIColor { get }
    var successViewBackgroundColor: UIColor { get }
    var actionSheetButtonColor: UIColor { get }
    var shadowButtonDimmedColor: UIColor { get }
    var noDataFoundLabel: UIColor { get }
    var lookupsHeaderLabel: UIColor { get }
}


// MARK: - App Theme
extension App {
    enum Theme {
        case night
        case day

        static var current: Theme = .night

        var package: ColorPackage {
            switch self {
            case .day:
                return NightPackage()
            case .night:
                return NightPackage()
            }
        }
    }

    struct NightPackage: ColorPackage {
        var tabbarBackground: UIColor = UIColor(hex: 0x181818)
        var tabbarText: UIColor = UIColor(hex: 0x7f7f7f)
        var tabbarTint: UIColor = UIColor(hex: 0xff5942)
        var unselectedTabbarTint: UIColor = UIColor(hex: 0x7a7a7a)
        var viewBackground: UIColor = UIColor(hex: 0xffffff)
        var pageIndicatorTintColor = UIColor(hex: 0xB8B8B8)
        var currentPageIndicatorCurrentColor = UIColor(hex: 0xFF5942)
        var textFieldSelectedBorder: UIColor = UIColor(hex: 0xFF5942)
        var textFieldNotSelectedBorder: UIColor = UIColor(hex: 0xE3E3E3)
        var buttonBackgroundColor: UIColor = UIColor(hex: 0xFF5942)
        var dialogButtonColor = UIColor(hex: 0xFF5942)
        var tabActiveColor = UIColor(hex: 0xFF5942)
        var tabInActiveColor = UIColor(hex: 0x7A7A7A)
        var grayUnderLineColor = UIColor(hex: 0xE5E5E5)
        var successViewBackgroundColor = UIColor(hex: 0x000000, transparency: 0.3)
        var actionSheetButtonColor = UIColor(hex: 0xFF5942)
        var shadowButtonDimmedColor = UIColor(hex: 0x7A7A7A)
        var noDataFoundLabel = UIColor(hex: 0x312F2F)
        var lookupsHeaderLabel = UIColor(hex: 0x312F2F)
    }
}
