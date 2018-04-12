//
//  AppUtility.swift
//  uTanks
//
//  Created by Student on 4/12/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation
import UIKit

struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
            print("Orientation: \(orientation)")
        }
    }
    
    //to adjust lock and rotate to a desired orentation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {
            self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")

        }
    
}
