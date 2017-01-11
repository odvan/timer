//
//  Date.swift
//  ViewsLayersTraining
//
//  Created by Artur Kablak on 06/09/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import Foundation

let stopTimeKey = "stopTimeKey"


protocol TimerUpdate {
    
    func stopAnimation()
    //func timer()
    func notifyTimerCompleted(_ text: String)
    func updateLabel(_ text: String)

}

protocol TimerNotification {
    
    func scheduleNotification(_ fireTime: Date, twoMinutes signal: Bool, special mode: Bool, rest interval: TimeInterval?)
    func cancelNotification()
}

class TimerModel {
    
 //MARK: Constants & Variables
    
    var text: String?
    var timer: Timer?
    var fireTime: Date?
    var timeInterval: TimeInterval?
    var repeatInterval: TimeInterval?
    var signal: Bool = false
    var specialModeOn: Bool = false
    var restInterval: TimeInterval? = 300
    
    var delegate: TimerUpdate?
    var notificationDelegate: TimerNotification?

    var timerRunning: Bool = false {
        didSet {
            if (timerRunning) {
                //delegate?.timer()
                
                let ti = 0.1
                timer = Timer.scheduledTimer(timeInterval: ti, target: self, selector: #selector(TimerModel.timerUpdateInModel), userInfo: nil, repeats: true)
            }
            else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
//    func setStopTime(setInterval: NSTimeInterval) {
//        stopTime = NSDate(timeIntervalSinceNow: setInterval)
//    }
    
    //MARK: Timer core logic
    
    func checkForPreviousTimer() {
        
        fireTime = UserDefaults.standard.object(forKey: stopTimeKey) as? Date
        if let time = fireTime {
            if time.compare(Date()) == .orderedDescending {
                startTimer(time)
            } else {
                stopTimer()
                //delegate?.notifyTimerCompleted(text!)
            }
        }
    }
    
    func startTimer(_ fireTime: Date) {
        timerRunning = true
        //self.stopTime = stopTime
        repeatInterval = fireTime.timeIntervalSinceNow
        UserDefaults.standard.set(fireTime, forKey: stopTimeKey)
        print("start timer: \(self.fireTime)")
        
        notificationDelegate?.scheduleNotification(fireTime, twoMinutes: signal, special: specialModeOn, rest: restInterval)
    }
    
    func stopTimer() {
        timerRunning = false
        notificationDelegate?.cancelNotification()
        UserDefaults.standard.set(nil, forKey: stopTimeKey)
    }
    
    func pauseTimer() {
        timerRunning = false
        notificationDelegate?.cancelNotification()
        timeInterval = fireTime!.timeIntervalSinceNow
        print("timeInterval: \(timeInterval!)")
    }
    
    func resumeTimer() {
        fireTime = Date(timeIntervalSinceNow: timeInterval!)
        print("new stop time date: \(fireTime!)")
        startTimer(fireTime!)

    }
    
    func repeatTimer() {
        stopTimer()
        fireTime = Date(timeIntervalSinceNow: repeatInterval!)
        startTimer(fireTime!)
        print("repeatTimer")
    }
    
    func firedTimer() {
        timerRunning = false
        text = "Timer done!"
        delegate?.notifyTimerCompleted(text!)
    }
    
    @objc func timerUpdateInModel() {
        
        let now = Date()
        
        if fireTime!.compare(now) == .orderedDescending {
            var someInterval: Double = round(fireTime!.timeIntervalSinceNow)
            timeInterval = fireTime!.timeIntervalSinceNow
            
            if specialModeOn {
                if someInterval > restInterval! {
                    someInterval -= restInterval!
                }
            }
            
            let hours = UInt(someInterval/3600)
            let minutes = UInt((someInterval/60).truncatingRemainder(dividingBy: 60))
            let seconds = UInt(someInterval.truncatingRemainder(dividingBy: 60))
            
            let strMinutes = String(format: "%02d", minutes)
            let strSeconds = String(format: "%02d", seconds)
            
            text = hours > 0 ? "\(hours):\(strMinutes):\(strSeconds)" : "\(strMinutes):\(strSeconds)"
            
            delegate?.updateLabel(text!)
            
            //NSNotificationCenter.defaultCenter().postNotificationName("labelUpdate", object: self, userInfo: nil)
        
        }  else {
            
           firedTimer()
            
        }

    }
    
}
