import UIKit
import QorumLogs
import Foundation

class ViewController: UIViewController
{
    //Declaring Variables
    var i: Int = 0
    var numberOfExperimentsPassed :Int = 1
    var roundCounter :Int = 1
    var touchArray = [CGFloat]()
    var targetValues = ["10", "20", "30", "40", "50", "60", "70", "80", "90"]
    var currentTargetValue : Int = 0
    var currentIndex : Int = 0
    
    var userAge :String = ""
    var userHanded :String = ""
    var used3DTouch :Bool = false
    var startTime: CFAbsoluteTime!
    var matchedTargetValue : Bool = false

    //The Users UUID
    let uuid = NSUUID().UUIDString
    let numberOfExperimentsToPass :Int = 3
    
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
        setTargetValueToFirstOfArray()
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
            
            if (forceRoundingCGFloat(touchArray[i-7]) >= currentTargetValue - 2   &&  forceRoundingCGFloat(touchArray[i-7]) <= currentTargetValue + 2 ) {
                sliderValueLabel.textColor = UIColor.greenColor()
            } else {
                sliderValueLabel.textColor = UIColor.darkGrayColor()
            }
        }
        
        if(recognizer.state == .Ended) {
            let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
            let seconds = 1.0
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            guard touchArray.count > 7 else {
                QL2(timeRounding(elapsedTime), force: String(forceRoundingCGFloat(touchArray[i-1])), targetForce: String(currentTargetValue), userAge: userAge, userHanded: userHanded, used3DTouch: String(used3DTouch), uuid: uuid, numberOfExperimentsPassed: String(numberOfExperimentsPassed), matchedTargetValue: String(matchedTargetValue), touchArray: String(touchArray))
                return
            }
            if (forceRoundingCGFloat(touchArray[i-7]) >= currentTargetValue - 2 && forceRoundingCGFloat(touchArray[i-7]) <= currentTargetValue + 2) {
                matchedTargetValue = true
            } else {
                matchedTargetValue = false
            }
            
            QL2(timeRounding(elapsedTime), force: String(forceRoundingCGFloat(touchArray[i-7])), targetForce: String(currentTargetValue), userAge: userAge, userHanded: userHanded, used3DTouch: String(used3DTouch), uuid: uuid, numberOfExperimentsPassed: String(numberOfExperimentsPassed), matchedTargetValue: String(matchedTargetValue), touchArray: String(touchArray))
            
            forceButton.enabled = false
            
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                
                self.forceButton.enabled = true
                self.sliderValueLabel.textColor = UIColor.darkGrayColor()
                self.prepareForNextRound()
                if (self.roundCounter < 10) {
                    self.showNextAlert()
                    return
                }
                
                if(self.numberOfExperimentsPassed == self.numberOfExperimentsToPass) {
                    self.showEndAlert();
                } else {
                    self.showFinalAlert()
                }
            })
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
        targetValues.removeAtIndex(currentIndex)
        setTargetValueToFirstOfArray()
    }
    
    func showFinalAlert() {
        let alert = UIAlertController(title: "Experiment " + String(numberOfExperimentsPassed)+" done.", message: MyClassConstants.NEXT_EXPERIMENT + " Only " + String(numberOfExperimentsToPass - numberOfExperimentsPassed)+" are left.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        sliderValueLabel.text = "0%"
        numberOfExperimentsPassed++
        setTargetValuesForRound(numberOfExperimentsPassed)
        resetRoundCounter()
        setTargetValueToFirstOfArray()
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
    
    func resetRoundCounter() {
        roundCounter = 1
    }
    
    func setTargetValuesForRound(numberOfExperimentsPassed : Int) {
        switch numberOfExperimentsPassed {
        case 2:
            targetValues = ["19", "38", "84", "42", "63", "57", "95", "76", "21"]
        case 3:
            targetValues =  ["81", "43", "15", "99", "24", "62", "36", "78", "57"]
        default:
            targetValues = ["10", "20", "30", "40", "50", "60", "70", "80", "90"]
        }
    }
    
    func prepareForNextRound() {
        sliderValueLabel.text = "0%"
        matchedTargetValue = false;
        roundCounter++
        touchArray = []
        i = 0;
    }
    
    func setTargetValueToFirstOfArray() {
        currentIndex = randomIndexFromArray(targetValues)
        let randomItem :String = targetValues[currentIndex]
        targetValueLabel.text = randomItem + "%"
        currentTargetValue = Int(randomItem)!
    }
    
    func randomIndexFromArray(array: Array<String>) -> Int {
        let index = Int(arc4random_uniform(UInt32(array.count)))
        return index
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.Portrait
    }
}

