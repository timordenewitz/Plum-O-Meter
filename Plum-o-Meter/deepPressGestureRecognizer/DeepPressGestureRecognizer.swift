//
//  DeepPressGestureRecognizer.swift
//  DeepPressGestureRecognizer
//
//  Created by SIMON_NON_ADMIN on 03/10/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//
//  Thanks to Alaric Cole - bridging header replaced by proper import :)

import AudioToolbox
import UIKit.UIGestureRecognizerSubclass
import QorumLogs


// MARK: GestureRecognizer

class DeepPressGestureRecognizer: UIGestureRecognizer
{
    var vibrateOnDeepPress = true
    
    private var target : UIViewController
    private var _force: CGFloat = 0.0
    
    internal var force: CGFloat {get {return _force}}
    
    required init(target: AnyObject?, action: Selector, threshold: CGFloat)
    {
        self.target = target as! UIViewController
        super.init(target: target, action: action)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent)
    {
        if let touch = touches.first
        {
            handleTouch(.Began,touch: touch)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent)
    {
        if let touch = touches.first
        {
            handleTouch(.Changed,touch: touch)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent)
    {
        super.touchesEnded(touches, withEvent: event)
        if let touch = touches.first
        {
            handleTouch(.Ended,touch: touch)
        }
    }
    
    private func handleTouch(state: UIGestureRecognizerState, touch: UITouch)
    {
        self.state = state
        
        _force = touch.force / touch.maximumPossibleForce
    }
    
    
    //This function is called automatically by UIGestureRecognizer when our state is set to .Ended. We want to use this function to reset our internal state.
    internal override func reset() {
        super.reset()
        
        _force = 0.0
    }
}

