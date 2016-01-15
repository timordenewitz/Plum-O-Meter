//
//  ThankYouViewController.swift
//  PressureTest
//
//  Created by Tim Ordenewitz on 15.01.16.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {

    @IBOutlet var startAgainButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func startAgainButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier("unwindToInfoViewController", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
