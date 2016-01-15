import UIKit
import QorumLogs
import Foundation


class PlaygroundViewController: UIViewController
{
    var i: Int = 0
    var roundCount: Int = 0
    var touchArray = [CGFloat]()
    
    var userAge :String = ""
    var userHanded :String = ""
    var used3DTouch :Bool = false
    
    var targetValues = [10, 20, 30, 40, 50, 60, 70, 80, 90]
    
    //All Messages to be Displayed
    struct MyClassConstants{
        static let START_MESSAGE = "Try to get comfortable with the force-input. You can change the value by applying or releaseing pressure on the Change Value button. Try to select different values. Please hold the device in your 'strong' Hand."
        static let TRY_AGAIN_MESSAGE = "Are you comfortable with the pressure input or do you want to try again?"
        static let START_EXPERIMENT = "Let's start the Experiment!"
        static let SELECTION_MESSAGE = "Selection is done by lifting your finger quickly. Try to come as close as you can to the target value and then lift your finger quickly."
    }
    
    var valueLabel: UILabel!
    @IBOutlet var changeValueButton: UIButton!
    @IBOutlet var targetValueLabel: UILabel!
    @IBOutlet var sliderValueLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.multipleTouchEnabled = true
        
        let deepPressGestureRecognizer = DeepPressGestureRecognizer(target: self, action: "deepPressHandler:", threshold: 0.0)
        
        changeValueButton.addGestureRecognizer(deepPressGestureRecognizer)
        targetValueLabel.text = String(targetValues.first!) + "%"
        targetValues.removeFirst(1)
    }
    
    override func viewDidAppear(animated: Bool) {
        let alert = UIAlertController(title: "This is your playground", message: MyClassConstants.START_MESSAGE, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: showMoreInfo))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func deepPressHandler(recognizer: DeepPressGestureRecognizer)
    {
        if(recognizer.state == .Began) {
            
        }
        if(recognizer.state == .Changed) {
            touchArray.insert(recognizer.force, atIndex: i)
            guard touchArray.count > 7 else {
                valueLabel.text = String(forceRoundingCGFloat((touchArray[i]))) + "%"
                i++
                return
            }
            valueLabel.text = String(forceRoundingCGFloat((touchArray[i-7]))) + "%"
            
            if (targetValueLabel.text == sliderValueLabel.text) {
                sliderValueLabel.textColor = UIColor.greenColor()
            }
            else {
                sliderValueLabel.textColor = UIColor.darkGrayColor()
            }
            i++
        }
        
        if(recognizer.state == .Ended) {
            roundCount++
            
            if(targetValues.count == 0) {
                targetValues = [10, 20, 30, 40, 50, 60, 70, 80, 90]
            }
            targetValueLabel.text = String(targetValues.first!) + "%"
            sliderValueLabel.text = "0%"
            targetValues.removeFirst(1)
            
            if (roundCount == 5) {
                let alert = UIAlertController(title: "Enough?", message: MyClassConstants.TRY_AGAIN_MESSAGE, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
                alert.addAction(UIAlertAction(title: "Start Experiment", style: UIAlertActionStyle.Default, handler: handleExperimentStart))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            if (roundCount == 10) {
                let alert = UIAlertController(title: "Now Enough?", message: MyClassConstants.TRY_AGAIN_MESSAGE, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
                alert.addAction(UIAlertAction(title: "Start Experiment", style: UIAlertActionStyle.Default, handler: handleExperimentStart))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            if (roundCount == 15) {
                let alert = UIAlertController(title: "Enough!", message: MyClassConstants.START_EXPERIMENT, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Start Experiment", style: UIAlertActionStyle.Default, handler: handleExperimentStart))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func handleExperimentStart(action :UIAlertAction) -> Void{
        performSegueWithIdentifier("showExperiment", sender: self)
    }
    
    func showMoreInfo(action :UIAlertAction) -> Void{
        let alert = UIAlertController(title: "Selection", message: MyClassConstants.SELECTION_MESSAGE, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Alright", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)    }
    
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
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let theDestination = (segue.destinationViewController as! ViewController)
        theDestination.userAge = userAge
        theDestination.userHanded = userHanded
        theDestination.used3DTouch = used3DTouch
    }    
}


