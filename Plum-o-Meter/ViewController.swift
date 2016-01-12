//
//  ViewController.swift
//  Plum-o-Meter
//
//  Created by Simon Gladman on 24/10/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit
import QorumLogs

class ViewController: UIViewController
{
    var i: Int = 0;
    var touchArray = [CGFloat]()
    
    var startTime: CFAbsoluteTime!

    @IBOutlet var forceButton: UIButton!
    @IBOutlet var slider: UISlider!
    @IBOutlet var sliderValueLabel: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.multipleTouchEnabled = true
        
        let deepPressGestureRecognizer = DeepPressGestureRecognizer(target: self, action: "deepPressHandler:", threshold: 0.0)
        
        forceButton.addGestureRecognizer(deepPressGestureRecognizer)
    }
    
    override func viewDidAppear(animated: Bool) {
        let alert = UIAlertController(title: "Willkommen", message: "Hier musst du den Slider mit Druck auf den gewünschten Wert einstellen! Drück auf den Change Value Button um den Wert des Sliders zu ändern!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "All right", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func deepPressHandler(recognizer: DeepPressGestureRecognizer)
    {
        if(recognizer.state == .Began) {
            startTime = CFAbsoluteTimeGetCurrent()

        }
        if(recognizer.state == .Changed) {
            touchArray.insert(recognizer.force, atIndex: i)
            guard touchArray.count > 5 else {
                slider.value = Float(touchArray[i])
                sliderValueLabel.text = String(slider.value * 100) + "%"
                i++
                return
            }
            slider.value = Float(touchArray[i-5])
            sliderValueLabel.text = String(slider.value * 100) + "%"
            i++
        }
        
        if(recognizer.state == .Ended) {
            let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
            guard touchArray.count > 6 else {
                QL2(timeRounding(elapsedTime), force: String(touchArray[i-1]*100))
                return
            }
            QL2(timeRounding(elapsedTime), force: String(touchArray[i-6]*100))
        }
    }
    
    func timeRounding(time : Double) -> String {
        let numberOfPlaces = 2.0
        let multiplier = pow(10.0, numberOfPlaces)
        let rounded = round(time * multiplier) / multiplier
        print(rounded)
        return String(rounded)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.Portrait
    }
    
}


