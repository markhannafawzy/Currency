//
//  UIUtils.swift
//
//  Created by Mark Hanna on 8/18/19.
//

import Foundation
import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class UIUtils {
    
}

// To lock orintation when needed
/* Usage: AppDelegate
    var orientationLock = UIInterfaceOrientationMask.all
     func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?)
     -> UIInterfaceOrientationMask {
        return self.orientationLock
     }
*/
struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask,
                                andRotateTo rotateOrientation: UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
}
