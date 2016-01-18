//
//  InfoViewController.swift
//  PressureTest
//
//  Created by Tim Ordenewitz on 14.01.16.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet var ageInput: UITextField!
    @IBOutlet var handednessTextField: UITextField!
    @IBOutlet var used3DTouchSwitch: UISwitch!
    
    var pickerData: [String] = ["Right-Handed", "Left-Handed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.alpha = CGFloat(1)
        pickerView.opaque = true
        pickerView.backgroundColor = UIColor.whiteColor()

        handednessTextField.inputView = pickerView

    }

    @IBAction func handednessClickedHandler(sender: AnyObject) {
        if(handednessTextField.text == "") {
            handednessTextField.text = pickerData.first
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        handednessTextField.text = pickerData[row]
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let theDestination = (segue.destinationViewController as! PlaygroundViewController)
        theDestination.userAge = ageInput.text!
        theDestination.userHanded =  handednessTextField.text!
        theDestination.used3DTouch = used3DTouchSwitch.on
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    
    override func viewDidAppear(animated: Bool) {
        handednessTextField.text = ""
        ageInput.text = ""
        used3DTouchSwitch.setOn(false, animated: false)
    }

}
