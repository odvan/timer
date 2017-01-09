//
//  AppDelegate.swift
//  ViewsLayersTraining
//
//  Created by Artur Kablak on 05/09/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import UIKit
import AVFoundation

let mainSignal = "chime_big_ben.wav"
let twoMinutesSignal = "bicycle_bell.wav"
let restSignal = "fanfare3.wav"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let timerModel = TimerModel()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let vc = window?.rootViewController as? TimerViewController {
            vc.timerModel = timerModel
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let time = timerModel.fireTime {
            if time.compare(Date()) != .orderedDescending {
                UIApplication.shared.cancelAllLocalNotifications()
                timerModel.delegate?.stopAnimation()
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: Foreground Alerts setups
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        //timerModel.firedTimer()
        print("didReceiveLocalNotification")
        
        var topController: UIViewController = (application.keyWindow?.rootViewController)!
        
        while ((topController.presentedViewController) != nil) {
            
            topController = topController.presentedViewController!
        }

        if application.applicationState == .active {
            
            switch notification.soundName! {
            
            case mainSignal:
                
                //UIApplication.sharedApplication().cancelAllLocalNotifications()
                let alertTimerEnds = UIAlertController(title: "Timer finished!", message: nil, preferredStyle: .alert)
                playAlarm(alarmBigBen)
                
                alertTimerEnds.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.timerModel.delegate?.stopAnimation()
                    self.audioPlayer.stop()
                }))
                alertTimerEnds.addAction(UIAlertAction(title: "Repeat", style: .default, handler: { _ in
                    self.timerModel.repeatTimer()
                    self.timerModel.delegate?.stopAnimation()
                    self.audioPlayer.stop()
                }))
                
                //window?.rootViewController?.presentViewController(alertTimerEnds, animated: true, completion: nil)
                topController.present(alertTimerEnds, animated: true, completion: nil)
                
            case twoMinutesSignal:
                playAlarm(twoMinutes)
                
            case restSignal:
                playAlarm(fanfare)
                
            default:
                 print("Unrecognisable")
            }
        }
    }
    
    //MARK: Sound setups
    
    var audioPlayer = AVAudioPlayer()
    
    let twoMinutes = "bicycle_bell"
    let alarmBigBen = "chime_big_ben"
    let fanfare = "fanfare3"
    
    func playAlarm(_ fileName: String?) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
                
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "wav")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
        } catch { debugPrint("\(error)") }
        
    }
    

    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        // Pass the action name onto the manager
        switch (identifier!) {
            case "repeat":
                timerModel.repeatTimer()
                timerModel.delegate?.stopAnimation()
            case "blank":
                print("fuuuck")
        default:
            print("Error, help!")

        }
        completionHandler()
    }
    
}

/*
 if #available(iOS 10.0, *) {
 let center = UNUserNotificationCenter.currentNotificationCenter()
 center.requestAuthorizationWithOptions([.Alert, .Sound]) { (granted, error) in
 // Enable or disable features based on authorization.
 }
 } else {
 // Fallback on earlier versions
 }
 */

