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
        let alert = UIAlertController(title: "Welcome", message: "Hier musst du durch Druck auf den Change Value Button versuchen die 2 Anzeigen auf den Gleichen Wert zu bringen!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "All right", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        targetValueLabel.text = String(targetValues.first!) + "%"
        targetValues.removeFirst(1)
    }
    
    func deepPressHandler(recognizer: DeepPressGestureRecognizer)
    {
        if(recognizer.state == .Began) {
            startTime = CFAbsoluteTimeGetCurrent()

        }
        if(recognizer.state == .Changed) {
            touchArray.insert(recognizer.force, atIndex: i)
            guard touchArray.count > 5 else {
                sliderValueLabel.text = String(forceRoundingCGFloat((touchArray[i]))) + "%"
                i++
                return
            }
            sliderValueLabel.text = String(forceRoundingCGFloat((touchArray[i-7]))) + "%"
            i++
        }
        
        if(recognizer.state == .Ended) {
            let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
            guard touchArray.count > 6 else {
                QL2(timeRounding(elapsedTime), force: String(forceRoundingCGFloat(touchArray[i-1])))
                return
            }
            QorumOnlineLogs.extraInformation["targetValue"] = targetValueLabel.text
            QorumOnlineLogs.extraInformation["age"] = userAge
            QorumOnlineLogs.extraInformation["handed"] = userHanded

            if (targetValueLabel.text == sliderValueLabel.text) {
                QorumOnlineLogs.extraInformation["matchedTargetValue"] = "true"
            }
            else {
                QorumOnlineLogs.extraInformation["matchedTargetValue"] = "false"
            }
            QL2(timeRounding(elapsedTime), force: String(forceRoundingCGFloat(touchArray[i-8])))
            roundCounter++
            if (roundCounter < 10) {
                showNextAlert()
                return
            }
            showFinalAlert()
        }
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
        let alert = UIAlertController(title: "Runde" + String(roundCounter), message: "Und noch mal — Bald hast dus geschafft!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay, weiter!", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        targetValueLabel.text = String(targetValues.first!) + "%"
        targetValues.removeFirst(1)
    }
    
    func showFinalAlert() {
        let alert = UIAlertController(title: "Vorbei!", message: "Vielen Dank fürs Mitmachen!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cool!", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        targetValueLabel.text = "---"
        sliderValueLabel.text = "---"
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.Portrait
    }
    
}


