//
//  ViewController.swift
//  Plum-o-Meter
//
//  Created by Simon Gladman on 24/10/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    let label = UILabel()
    
    var lastMovedForce :CGFloat = 0
    
    var circles = [UITouch: CircleWithLabel]()
    
    let deepPressableButton = DeepPressableButton(type: UIButtonType.System)
    
    var i: Int = 0
    
    var touched = [CGFloat]()

    @IBOutlet var forceButton: UIButton!
    @IBOutlet var slider: UISlider!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.multipleTouchEnabled = true
        
        label.text = "Change the Background color!"
        
        label.textAlignment = NSTextAlignment.Center
        
        view.addSubview(label)

        let deepPressGestureRecognizer = DeepPressGestureRecognizer(target: self, action: "deepPressHandler:", threshold: 0.0)
        
        forceButton.addGestureRecognizer(deepPressGestureRecognizer)
        
    }
    
    func deepPressHandler(value: DeepPressGestureRecognizer)
    {
        if value.state == UIGestureRecognizerState.Began
        {
        }
        else if value.state == UIGestureRecognizerState.Ended
        {
        }
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
//    {
//        label.hidden = true
//        
//        for touch in touches
//        {
//            let circle = CircleWithLabel()
//            
//            circle.drawAtPoint(touch.locationInView(view),
//                force: touch.force / touch.maximumPossibleForce)
//            
//            circles[touch] = circle
//            view.layer.addSublayer(circle)
//        }
//        
//        highlightHeaviest()
//    }
//    
//    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
//    {
//        for touch in touches where circles[touch] != nil
//        {
//            let circle = circles[touch]!
//            
//            circle.drawAtPoint(touch.locationInView(view),
//                force: touch.force / touch.maximumPossibleForce)
//            if(touch.force < 1) {
//                self.view.backgroundColor = UIColor.redColor()
//            }
//            if(touch.force > 1 && touch.force < 5) {
//                self.view.backgroundColor = UIColor.greenColor()
//
//            }
//            if (touch.force > 5) {
//                self.view.backgroundColor = UIColor.yellowColor()
//            }
//            lastMovedForce = touch.force
//        }
//        
//        highlightHeaviest()
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
//    {
//        for touch in touches where circles[touch] != nil
//        {
//            let circle = circles[touch]!
//            
//            circles.removeValueForKey(touch)
//            circle.removeFromSuperlayer()
//            
//        }
//        
//        highlightHeaviest()
//    }
//    
//    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?)
//    {
//        guard let touches = touches else
//        {
//            return
//        }
//        
//        for touch in touches where circles[touch] != nil
//        {
//            let circle = circles[touch]!
//            
//            circle.removeFromSuperlayer()
//        }
//    }
    
    func highlightHeaviest()
    {
        func getMaxTouch() -> UITouch?
        {
            return circles.sort({
                (a: (UITouch, CircleWithLabel), b: (UITouch, CircleWithLabel)) -> Bool in
                
                return a.0.force > b.0.force
            }).first?.0
        }
        
        circles.forEach
        {
            $0.1.isMax = $0.0 == getMaxTouch()
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewDidLayoutSubviews()
    {
        label.frame = view.bounds
    }
}

// -------------

class CircleWithLabel: CAShapeLayer
{
    let text = CATextLayer()
    
    override init()
    {
        super.init()
        
        text.foregroundColor = UIColor.blueColor().CGColor
        text.alignmentMode = kCAAlignmentCenter
        addSublayer(text)
        
        strokeColor = UIColor.blueColor().CGColor
        lineWidth = 5
        fillColor = nil
    }
    
    override init(layer: AnyObject)
    {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isMax: Bool = false
    {
        didSet
        {
            fillColor = isMax ? UIColor.greenColor().CGColor : nil
        }
    }
    
    func drawAtPoint(location: CGPoint, force: CGFloat)
    {
        let radius = 30 + (force * 120)
        
        path = UIBezierPath(
            ovalInRect: CGRect(
                origin: location.offset(dx: radius, dy: radius),
                size: CGSize(width: radius * 2, height: radius * 2))).CGPath
        
        text.string = String(format: "%.1f%%", force * 100)
        
        text.frame = CGRect(origin: location.offset(dx: 75, dy: -radius), size: CGSize(width: 150, height: 40))
    }
}

// -------------

extension CGPoint
{
    func offset(dx dx: CGFloat, dy: CGFloat) -> CGPoint
    {
        return CGPoint(x: self.x - dx, y: self.y - dy)
    }
}

class DeepPressableButton: UIButton, DeepPressable
{
    
}
