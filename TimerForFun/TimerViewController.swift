//
//  ViewController.swift
//  ViewsLayersTraining
//
//  Created by Artur Kablak on 05/09/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
   // MARK: Constants & Variables
    
    var timerModel = TimerModel()
    var notificationsModel = NotificationsModel()
    
    var simpleRing = SimpleRing()
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerPicker: UIDatePicker!
    
    //let someLabel = UILabel()
    let picker = UIPickerView()
    var pickerData = [["20", "25", "30", "35", "40", "45", "50", "55"],["5", "10", "15", "20", "25", "30"]]
    var stackView = UIStackView()
    var specialTimeInterval: TimeInterval? = 25
    
    @IBOutlet weak var timerConstraintMidY: NSLayoutConstraint!

    let buttonOne = MyButton(type: UIButtonType.custom)
    let buttonTwo = MyButton(type: UIButtonType.custom)
    
    var compactConstraints = [NSLayoutConstraint]()
    var regularConstraints = [NSLayoutConstraint]()
    
    let interactor = Interactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        timerModel.specialModeOn = UserDefaults.standard.bool(forKey: "specialModeOn")
        timerConstraintMidY.constant = (timerModel.specialModeOn) ? -480 : 0

        timerModel.delegate = self
        timerModel.notificationDelegate = notificationsModel
        setupSimpleRing()
        pauseButton()
        startButton()
        stackSetup()//labelSpecialSetup()
    
        timerModel.checkForPreviousTimer()
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.method), name: "labelUpdate", object: nil)
        
        timerPicker.backgroundColor = UIColor.white //(red: 255/255, green: 175/255, blue: 240/255, alpha: 1.0)
        timerPicker.layer.cornerRadius = 35
        timerPicker.layer.masksToBounds = true
        
    }
    
//    func method() {
//        timerLabel.text = timerModel.text
//    }
    
    // MARK: TimePicker & Buttons setups
    
    private func stackSetup() {
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        picker.backgroundColor = UIColor.white
        picker.layer.cornerRadius = 35
        view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        picker.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        let label = UILabel()
        label.text = "Choose WORK interval + REST interval"
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        stackView = UIStackView(arrangedSubviews: [label, picker])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        stackView.alpha = (timerModel.specialModeOn) ? 1.0 : 0
        
    }
    
    
    fileprivate func setupSimpleRing() {
        
        view.addSubview(simpleRing)

        //simpleRing.backgroundColor = UIColor(red: 0, green: 0.7, blue: 1, alpha: 1)
        simpleRing.isOpaque = false
        
        simpleRing.translatesAutoresizingMaskIntoConstraints = false
        
        simpleRing.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        simpleRing.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        simpleRing.widthAnchor.constraint(equalToConstant: min(view.bounds.size.width, view.bounds.size.height)*0.8).isActive = true
        simpleRing.heightAnchor.constraint(equalTo: simpleRing.widthAnchor).isActive = true
        simpleRing.alpha = 0
        
    }
    
    fileprivate func pauseButton() {
        
        buttonOne.isEnabled = false
        buttonOne.setTitle("Pause", for: .normal)
        buttonOne.backgroundColor = UIColor(red: 210/255, green: 50/255, blue: 150/255, alpha: 0.4)
        
        buttonOne.addTarget(self, action: #selector(TimerViewController.pauseResumeTimer), for: UIControlEvents.touchUpInside)
        
        view.addSubview(buttonOne)
        
        buttonOne.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = buttonOne.widthAnchor.constraint(equalToConstant: min(view.bounds.size.width, view.bounds.size.height)/5)
        widthConstraint.priority = 750
        widthConstraint.isActive = true
        buttonOne.widthAnchor.constraint(lessThanOrEqualToConstant: 90).isActive = true
        buttonOne.heightAnchor.constraint(equalTo: buttonOne.widthAnchor).isActive = true
        
        regularConstraints.append(simpleRing.topAnchor.constraint(equalTo: buttonOne.bottomAnchor, constant: 50))
        regularConstraints.append(buttonOne.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        compactConstraints.append(simpleRing.leadingAnchor.constraint(equalTo: buttonOne.trailingAnchor, constant: 50))
        compactConstraints.append(buttonOne.centerYAnchor.constraint(equalTo: view.centerYAnchor))
    }
    
    fileprivate func startButton() {
        
        buttonTwo.setTitle("Start", for: .normal)
        buttonTwo.backgroundColor = UIColor(red: 210/255, green: 50/255, blue: 150/255, alpha: 1.0)
        
        buttonTwo.addTarget(self, action: #selector(TimerViewController.startStopTimer), for: UIControlEvents.touchUpInside)
        
        view.addSubview(buttonTwo)
        
        buttonTwo.translatesAutoresizingMaskIntoConstraints = false
        
        buttonTwo.heightAnchor.constraint(equalTo: buttonOne.widthAnchor).isActive = true
        buttonTwo.widthAnchor.constraint(equalTo: buttonTwo.heightAnchor).isActive = true
        
        regularConstraints.append(buttonTwo.topAnchor.constraint(equalTo: simpleRing.bottomAnchor, constant: 50))
        regularConstraints.append(buttonTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        compactConstraints.append(buttonTwo.leadingAnchor.constraint(equalTo: simpleRing.trailingAnchor, constant: 50))
        compactConstraints.append(buttonTwo.centerYAnchor.constraint(equalTo: view.centerYAnchor))
    }
    
    fileprivate func enableConstraintsForWidth() {
        
        if view.bounds.height > view.bounds.width { //traitCollection.verticalSizeClass == .Regular
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
            print("regular")
        }
        else {
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
            print("compact")
        }
        
    }

//    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        
//        enableConstraintsForWidth()
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        enableConstraintsForWidth()
    }

    // MARK: Buttons logic, methods and actions
    
    fileprivate func movingTimerPicker() {
        
            UIView.animate(withDuration: 0.5, animations: {
                if self.timerModel.specialModeOn || self.timerModel.timerRunning { //self.timerConstraintMidY.constant == 0 ||
                    self.timerConstraintMidY.constant = -480
                    self.timerPicker.alpha = 0
                    self.simpleRing.alpha = 1.0
                } else {
                    self.timerConstraintMidY.constant = 0
                    self.timerPicker.alpha = 1.0
                    self.simpleRing.alpha = 0
                }
                self.view.layoutIfNeeded()
            })
    
    }
        
    fileprivate func managingSpecialModeLabelAndTimerPicker() {
        
        if (timerModel.specialModeOn) && (!timerModel.timerRunning) {
            stackView.alpha = 1.0
        } else {
            stackView.alpha = 0
        }
    }
    
    @objc fileprivate func startStopTimer(_ sender: MyButton) {
        
        timerModel.specialModeOn = UserDefaults.standard.bool(forKey: "specialModeOn")
        
        if (!timerModel.timerRunning) && (!buttonOne.isEnabled) {
            sender.isSelected = true
            buttonOne.isEnabled = true
            //timerModel.setStopTime(timerPicker.countDownDuration)
            //timerModel.specialModeOn = NSUserDefaults.standardUserDefaults().boolForKey("specialModeOn")
            if timerModel.specialModeOn {
                timerModel.fireTime = Date(timeIntervalSinceNow: (specialTimeInterval! * 60))
                simpleRing.specialMode = true
                timerModel.restInterval = TimeInterval(pickerData[1][picker.selectedRow(inComponent: 1)])! * 60
                print("rest interval: \(timerModel.restInterval)")
                simpleRing.restIntervalSR = timerModel.restInterval
            } else {
                timerModel.fireTime = Date(timeIntervalSinceNow: timerPicker.countDownDuration)
                simpleRing.specialMode = false
            }
            if let time = timerModel.fireTime {
                timerModel.signal = UserDefaults.standard.bool(forKey: "switchState")
                timerModel.startTimer(time)
            }
            movingTimerPicker()
            managingSpecialModeLabelAndTimerPicker()


        } else {
            sender.isSelected = false
            buttonOne.isSelected = false
            buttonOne.isEnabled = false
            timerModel.stopTimer()
            //simpleRing.timerDuration = nil
            print("stopped")
            movingTimerPicker()
            managingSpecialModeLabelAndTimerPicker()

        }
    }
    
    @objc fileprivate func pauseResumeTimer(_ sender: MyButton) {
        print("button pressed")
        
        if (timerModel.timerRunning) {
            sender.isSelected = true
            timerModel.pauseTimer()
        } else {
            sender.isSelected = false
            timerModel.resumeTimer()
        }
    }


//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        //LightContent
        return UIStatusBarStyle.lightContent
        //Default
        //return UIStatusBarStyle.Default
    }
    
    // MARK: Segue preparations for Custom Modal Presentation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SetupsTVC {
            destinationViewController.transitioningDelegate = self
            destinationViewController.modalPresentationStyle = .custom
            destinationViewController.interactor = interactor // new
        }
    }
    
  }

// MARK: TimerUpdate protocol methods

extension TimerViewController: TimerUpdate {
    
    func stopAnimation() {
        
        simpleRing.transform = CGAffineTransform.identity
        simpleRing.layer.removeAllAnimations()
        movingTimerPicker()
        print("stopAnimation")
        
    }
    
    func updateLabel(_ text: String) {
        simpleRing.timerDuration = round(timerModel.timeInterval!)
        timerLabel.text = text
    }

//    func timer() {
//        let ti = 0.1
//        
//        timerModel.timer = NSTimer.scheduledTimerWithTimeInterval(ti, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
//    }
    
    func notifyTimerCompleted(_ text: String) {
        
        timerLabel.text = text
        
        buttonOne.isEnabled = false
        buttonTwo.isSelected = false
        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [.autoreverse, .repeat], animations:
            { self.simpleRing.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            },
                                   completion: { finished in
                                    //self.movingTimerPicker()
                                    //self.stopAnimation()
                                    print("animation-completion")
        })
    }

}


extension TimerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
       specialTimeInterval = TimeInterval(pickerData[0][picker.selectedRow(inComponent: 0)])! +  TimeInterval(pickerData[1][picker.selectedRow(inComponent: 1)])!
    }
}

extension TimerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    
}
