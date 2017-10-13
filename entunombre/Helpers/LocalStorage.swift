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
    
    func setTutorialShown(isShown:Bool) {
        defaults.set(isShown, forKey: tutorialShownKey)
    }
    
    func isTutorialShown() -> Bool {
        return defaults.bool(forKey: tutorialShownKey)
    }
    
    func setFcmToken(token:String) {
        defaults.set(token, forKey: fcmTokenKey)
    }
    
    func getFcmToken() -> String {
        if let token = defaults.string(forKey: fcmTokenKey) {
            return token
        }
        return ""
    }
    
    func clearNotifications() {
        setNotifications(notifications: [])
    }
    
    func setNotifications(notifications:[LocalNotification]) {
        let encondedData = NSKeyedArchiver.archivedData(withRootObject: notifications)
        defaults.set(encondedData, forKey: notificationsKey)
    }
    
    
    func getNotifications() -> [LocalNotification] {
        if let decoded = defaults.object(forKey: notificationsKey) as? Data {
            if let notifications = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [LocalNotification] {
                return notifications
            }
        }
        return []
    }
    
    func appendNotification(notification:LocalNotification) {
        if let decoded = defaults.object(forKey: notificationsKey) as? Data {
            if var notifications = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [LocalNotification] {
                notifications.append(notification)
                
                let encondedData = NSKeyedArchiver.archivedData(withRootObject: notifications)
                defaults.set(encondedData, forKey: notificationsKey)
            }
            
            return
        }
        
        let encondedData = NSKeyedArchiver.archivedData(withRootObject: [notification])
        defaults.set(encondedData, forKey: notificationsKey)
    }
    
    func appendNotifications(notifications:[LocalNotification]) {
        if let decoded = defaults.object(forKey: notificationsKey) as? Data {
            if var notifications = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [LocalNotification] {
                notifications.append(contentsOf: notifications)
                
                let encondedData = NSKeyedArchiver.archivedData(withRootObject: notifications)
                defaults.set(encondedData, forKey: notificationsKey)
            }
            return
        }
        
        let encondedData = NSKeyedArchiver.archivedData(withRootObject: notifications)
        defaults.set(encondedData, forKey: notificationsKey)
    }
    
    func setNotificationsViewed(notificationsToUpdate:[LocalNotification]) {
        if let decoded = defaults.object(forKey: notificationsKey) as? Data {
            if var notifications = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [LocalNotification] {
                for notif in notificationsToUpdate {
                    notif.isViewed = true
                    let index = notifications.index(where: {(item) -> Bool in
                        item.createdAt == notif.createdAt && item.vehicleId == notif.vehicleId
                    })
                    notifications[index!] = notif
                }
                
                let encondedData = NSKeyedArchiver.archivedData(withRootObject: notifications)
                defaults.set(encondedData, forKey: notificationsKey)
            }
            return
        }
    }
    
    
    func setCurrentVehicleId(vehicleId:String) {
        defaults.set(vehicleId, forKey: vehicleIdKey)
    }
    
    func getCurrentVehicleId() -> String {
        if let vehicleId = defaults.string(forKey: vehicleIdKey) {
            return vehicleId
        }
        return ""
    }
}
