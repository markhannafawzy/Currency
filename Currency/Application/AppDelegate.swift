//
//  AppDelegate.swift
//  Currency
//
//  Created by Mark Hanna. on 12/16/18.
//  Copyright © 2018 Mark Hanna. All rights reserved.
//

import UIKit
import RxSwift
import IQKeyboardManagerSwift

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        window = UIWindow(frame: UIScreen.main.bounds)
        Application.current.root(in: window)
        window?.makeKeyAndVisible()
        #if DEBUG
        NFX.sharedInstance().start()
        #endif
        return true
    }
    
    // MARK: For controlling orientation
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?)
        -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
}
