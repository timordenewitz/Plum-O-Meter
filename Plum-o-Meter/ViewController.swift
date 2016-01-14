//
//  ViewController.swift
//  Plum-o-Meter
//
//  Created by Simon Gladman on 24/10/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit
import QorumLogs
import Foundation


class ViewController: UIViewController
{
    var i: Int = 0
    var roundCounter :Int = 1
    var touchArray = [CGFloat]()
    var targetValues = [10, 20, 30, 40, 50, 60, 70, 80, 90]
    
    var userAge :String = ""
    var userHanded :String = ""
    var used3DTouch :Bool = false
    
    var startTime: CFAbsoluteTime!

    let uuid = NSUUID().UUIDString
    
    @IBOutlet var forceButton: UIButton!
    @IBOutlet var sliderValueLabel: UILabel!
    @IBOutlet var targetValueLabel: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.multipleTouchEnabled = true
        
        let deepPressGestureRecognizer = DeepPressGestureRecognizer(target: self, action: "deepPressHandler:", threshold: 0.0)
        
        forceButton.addGestureRecognizer(deepPressGestureRecognizer)
    }
    
    override func viewDidAppear(animated: Bool) {
        let alert = UIAlertController(title: "Welcome", message: "Here, you have to try to match the 2 values by applying pressure on the Change Value Button.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "All right", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        targetValueLabel.text = String(targetValues.first!) + "%"
    }
    
    func deepPressHandler(recognizer: DeepPressGestureRecognizer)
    {
        if(recognizer.state == .Began) {
            startTime = CFAbsoluteTimeGetCurrent()

        }
        if(recognizer.state == .Changed) {
            touchArray.insert(recognizer.force, atIndex: i)
            guard touchArray.count > 7 else {
                sliderValueLabel.text = String(forceRoundingCGFloat((touchArray[i]))) + "%"
                i++
                return
            }
            sliderValueLabel.text = String(forceRoundingCGFloat((touchArray[i-7]))) + "%"
            i++
            
            if (targetValueLabel.text == sliderValueLabel.text) {
                sliderValueLabel.textColor = UIColor.greenColor()
            }
            else {
                sliderValueLabel.textColor = UIColor.darkGrayColor()
            }
            
        }
        
        if(recognizer.state == .Ended) {
            let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
            guard touchArray.count > 7 else {
                QL2(timeRounding(elapsedTime), force: String(forceRoundingCGFloat(touchArray[i-1])), targetForce: String(targetValues.first!))
                return
            }
            addExtraLogInformation()

            if (targetValueLabel.text == sliderValueLabel.text) {
                QorumOnlineLogs.extraInformation["matchedTargetValue"] = "true"
            }
            else {
                QorumOnlineLogs.extraInformation["matchedTargetValue"] = "false"
            }
            QL2(timeRounding(elapsedTime), force: String(forceRoundingCGFloat(touchArray[i-7])), targetForce: String(targetValues.first!))
            roundCounter++
            if (roundCounter < 10) {
                showNextAlert()
                return
            }
            showFinalAlert()
        }
    }
    
    func addExtraLogInformation() {
        QorumOnlineLogs.extraInformation["age"] = userAge
        QorumOnlineLogs.extraInformation["handed"] = userHanded
        QorumOnlineLogs.extraInformation["3DTouch-Experiance"] = String(used3DTouch)
        QorumOnlineLogs.extraInformation["uuid"] = uuid
    }
    
    func timeRounding(time : Double) -> String {
        let numberOfPlaces = 2.0
        let multiplier = pow(10.0, numberOfPlaces)
        let rounded = round(time * multiplier) / multiplier
        return String(rounded)
    }
    
    func forceRoundingCGFloat(force : CGFloat) -> Int {
        let numberOfPlaces = 2.0
        let doubleTime = Double(force)
        let multiplier = pow(10.0, numberOfPlaces)
        let rounded = round(doubleTime * multiplier) / multiplier
        return Int(rounded*100)
    }
    
    func showNextAlert() {
        let alert = UIAlertController(title: "Round" + String(roundCounter), message: "And again, " + String(10-roundCounter) + " Rounds left!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay, let's do this", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        targetValues.removeFirst(1)
        targetValueLabel.text = String(targetValues.first!) + "%"
    }
    
    func showFinalAlert() {
        let alert = UIAlertController(title: "Done", message: "Thanks for participating", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        targetValueLabel.text = "---"
        sliderValueLabel.text = "---"
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.Portrait
    }
    
}


