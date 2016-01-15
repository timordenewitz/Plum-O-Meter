import UIKit
import QorumLogs
import Foundation


class ViewController: UIViewController
{
    //Declaring Variables
    var i: Int = 0
    var numberOfExperimentsPassed :Int = 0
    var roundCounter :Int = 1
    var touchArray = [CGFloat]()
    var targetValues = [10, 20, 30, 40, 50, 60, 70, 80, 90]
    
    var userAge :String = ""
    var userHanded :String = ""
    var used3DTouch :Bool = false
    var startTime: CFAbsoluteTime!

    //The Users UUID
    let uuid = NSUUID().UUIDString
    let numberOfExperimentsToPass :Int = 5
    
    //All Messages to be Displayed
    struct MyClassConstants{
        static let WELCOME_MESSAGE = "Here, you have to try to match the 2 values by applying pressure on the Change Value Button."
        static let THANK_YOU_MESSAGE = "Thanks for participating"
        static let NEXT_EXPERIMENT = "Thanks for this one. It would be cool, if you can do another one!"

    }
    
    //The Outlets
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
        let alert = UIAlertController(title: "Welcome", message:MyClassConstants.WELCOME_MESSAGE , preferredStyle: UIAlertControllerStyle.Alert)
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
                QL2(timeRounding(elapsedTime), force: String(forceRoundingCGFloat(touchArray[i-1])), targetForce: String(targetValues.first!), userAge: userAge, userHanded: userHanded, used3DTouch: String(used3DTouch), uuid: uuid)
                return
            }

            if (targetValueLabel.text == sliderValueLabel.text) {
                QorumOnlineLogs.extraInformation["matchedTargetValue"] = "true"
            }
            else {
                QorumOnlineLogs.extraInformation["matchedTargetValue"] = "false"
            }
            QL2(timeRounding(elapsedTime), force: String(forceRoundingCGFloat(touchArray[i-7])), targetForce: String(targetValues.first!), userAge: userAge, userHanded: userHanded, used3DTouch: String(used3DTouch), uuid: uuid)
            roundCounter++
            if (roundCounter < 10) {
                showNextAlert()
                return
            }
            showFinalAlert()
            
            if(numberOfExperimentsPassed == numberOfExperimentsToPass) {
                showEndAlert();
            }
        }
    }
    
    @available(*, deprecated=1.0) func addExtraLogInformation() {
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
        let alert = UIAlertController(title: "Experiment " + String(numberOfExperimentsPassed)+" done.", message: MyClassConstants.NEXT_EXPERIMENT + "Only " + String(numberOfExperimentsToPass - numberOfExperimentsPassed)+" left.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        targetValueLabel.text = "---"
        sliderValueLabel.text = "---"
        numberOfExperimentsPassed++
    }
    
    func showEndAlert() {
        let alert = UIAlertController(title: "You're done", message: MyClassConstants.THANK_YOU_MESSAGE , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: handleExperimentEnd))
        self.presentViewController(alert, animated: true, completion: nil)
        targetValueLabel.text = "---"
        sliderValueLabel.text = "---"
    }
    
    func handleExperimentEnd(action :UIAlertAction) -> Void{
        performSegueWithIdentifier("ThankYouSegue", sender: self)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.Portrait
    }
    
}


