//
//  LocalStorage.swift
//  instacarro-waiting-room
//
//  Created by Eury Perez Beltre on 7/12/17.
//  Copyright © 2017 Eury Perez Beltre. All rights reserved.
//

import Foundation

class LocalStorage {

    static let shared = LocalStorage()
    let defaults = UserDefaults.standard
    
    //value keys
    let fcmTokenKey = "fcmTokenKey"
    let notificationsKey = "notifications"
    let vehicleIdKey = "vehicleIdKey"
    let tutorialShownKey = "tutorialShownKey"
    
    var isTutorialShown: Bool {
        set {
            defaults.set(newValue, forKey: tutorialShownKey)
        }
        get {
            return defaults.bool(forKey: tutorialShownKey)
        }
    }
}
