//
//  ViewModel.swift
//  ViewsLayersTraining
//
//  Created by Artur Kablak on 05/10/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import UIKit

class NotificationsModel  {
    
    //MARK: Registering local notifications (with action)
    
    fileprivate func registerForLocalNotifications() {
        let types: UIUserNotificationType = [.badge, .sound, .alert]
        let categories = Set(arrayLiteral: firedTimerNotificationCategory())
        let settings = UIUserNotificationSettings(types: types, categories: categories)
        
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
    
    fileprivate func firedTimerNotificationCategory() -> UIUserNotificationCategory {
        let repeatAction = UIMutableUserNotificationAction()
        repeatAction.identifier = "repeat"
        repeatAction.isDestructive = false
        repeatAction.title = "Repeat"
        repeatAction.activationMode = .background
        repeatAction.isAuthenticationRequired = false
        
        let category = UIMutableUserNotificationCategory()
        category.identifier = "TimerCategory"
        category.setActions([repeatAction], for: .minimal)
        category.setActions([repeatAction], for: .default)
        
        return category
    }

    
    init() {
        registerForLocalNotifications()
    }
    
}

//MARK: TimerNotification protocol methods 

extension NotificationsModel: TimerNotification {
    
    func scheduleNotification(_ fireTime: Date, twoMinutes signal: Bool, special: Bool, rest: TimeInterval?) {
        
        print("scheduled")
        
        let notification = UILocalNotification()
        notification.fireDate = fireTime
        notification.alertBody = "Timer finished!"
        notification.soundName = "chime_big_ben.wav"
        notification.category = "TimerCategory"
        UIApplication.shared.scheduleLocalNotification(notification)
        
        if fireTime.timeIntervalSinceNow > 120 && signal {
            
            let notificationTwoMinutes = UILocalNotification()
            notificationTwoMinutes.fireDate = Date(timeIntervalSinceNow: (fireTime.timeIntervalSinceNow - 120))
            notificationTwoMinutes.soundName = "bicycle_bell.wav"
            UIApplication.shared.scheduleLocalNotification(notificationTwoMinutes)
            
        }
        
        if special && fireTime.timeIntervalSinceNow > rest! {
            
                let notificationRestSignal = UILocalNotification()
                notificationRestSignal.fireDate = Date(timeIntervalSinceNow: (fireTime.timeIntervalSinceNow - rest!))
                notificationRestSignal.soundName = "fanfare3.wav"
                UIApplication.shared.scheduleLocalNotification(notificationRestSignal)

        }

    }
    
    func cancelNotification() {
        print("cancelNotification")
        UIApplication.shared.cancelAllLocalNotifications()

    }
}
