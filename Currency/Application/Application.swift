//
//  Application.swift
//  Currency
//
//  Created by Mark Hanna. on 12/16/18.
//  Copyright © 2018 Mark Hanna. All rights reserved.
//

import UIKit

final class Application {
    static let current = Application()
    var coodinator: RootCoordinator?

    private init() {}

    func root(in window: UIWindow?) {
        let coodinator = RootCoordinator()
        coodinator.window = window
        coodinator.showScreen(.mainScreen)
    }
}
