//
//  SetupsTVC.swift
//  PanGestureCustomTransition
//
//  Created by Artur Kablak on 17/10/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import UIKit

class SetupsTVC: UITableViewController {
    
    
    @IBOutlet weak var switchTwoMinutesButton: UISwitch!
    @IBOutlet weak var workBreakMode: UISwitch!
    
    var interactor: Interactor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchTwoMinutesButton.isOn =  UserDefaults.standard.bool(forKey: "switchState")
        workBreakMode.isOn = UserDefaults.standard.bool(forKey: "specialModeOn")
        
        tableView.panGestureRecognizer.addTarget(self, action: #selector(SetupsTVC.handleGesture(_:)))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switching(_ sender: AnyObject) {
        UserDefaults.standard.set(switchTwoMinutesButton.isOn, forKey: "switchState")
    }
    
    @IBAction func specialModeSwitching(_ sender: AnyObject) {
        UserDefaults.standard.set(workBreakMode.isOn, forKey: "specialModeOn")
    }
    
    @IBAction func doneSetups(_ sender: AnyObject) {
        
        let vc = presentingViewController as! TimerViewController
        vc.simpleRing.alpha = (vc.timerModel.timerRunning) || (vc.buttonOne.currentTitle == "Resume") ? 1.0 : 0
        
        if workBreakMode.isOn {
            vc.timerPicker.alpha = 0
            vc.stackView.alpha = (vc.timerModel.timerRunning) || (vc.buttonOne.currentTitle == "Resume") ? 0 : 1.0

        } else {
            vc.timerConstraintMidY.constant = (vc.timerModel.timerRunning) || (vc.buttonOne.currentTitle == "Resume") ? -480 : 0
            vc.timerPicker.alpha = 1.0
            vc.stackView.alpha = 0
        }
        
        dismiss(animated: true, completion: nil)
        
    }

    
    func progressAlongAxis(_ pointOnAxis: CGFloat, axisLength: CGFloat) -> CGFloat {
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
        let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
        return CGFloat(positiveMovementOnAxisPercent)
    }
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        
        let percentThreshold:CGFloat = 0.2
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        // using the helper method
        let progress = progressAlongAxis(translation.y, axisLength: view.bounds.height)
        
        guard let interactor = interactor,
            let originView = sender.view else { return }
        
        // Only let the table view dismiss the modal only if we're at the top.
        // If the user is in the middle of the table, let him scroll.
        switch originView {
        case view:
            break
        case tableView:
            if tableView.contentOffset.y > 0 {
                return
            }
        default:
            break
        }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            doneSetups(sender)//dismissViewControllerAnimated(true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }

}
