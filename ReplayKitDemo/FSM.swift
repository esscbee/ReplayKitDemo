//
//  FSM.swift
//  ReplayKitDemo
//
//  Created by Stephen Brennan on 8/18/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import UIKit
import GameKit


// game FSM

class MSReplayKitState : GKState {
    weak var gameDelegate : GameDelegate?
    weak var trackTouch : UITouch?
    init(gameDelegate: GameDelegate) {
        self.gameDelegate = gameDelegate
    }
    
    //
    // called when the record/stop button has been touched. return true to consume
    //
    func touchBegan(_ touch: UITouch) -> Bool {
        return true
    }
    //
    // calleed when button touch has moved. return true to consume
    //
    func touchMoved(_ onButton: Bool) -> Bool {
        return false
    }
    
    //
    // called when button touch has ended. return true to consume.
    //
    func touchEnded(_ onButton: Bool) -> Bool {
        return false
    }
    
    //
    // return true if the state consumed the touchesCancelled
    //
    func touchCancelled(_ onButton: Bool) -> Bool {
        return false
    }
    
    //
    // store a touch in the state
    //
    func setTouch(_ touch: UITouch) {
        self.trackTouch = touch
    }
    
    //
    // handle leaving the state
    //
    override func willExit(to nextState: GKState) {
        self.trackTouch = nil
    }
    
    override func didEnter(from previousState: GKState?) {
        // print(self.description)
    }
    
}

class MSWaitRecordState : MSReplayKitState {
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        if let gd = gameDelegate {
            gd.highlightRecordButton(highlight: false)
            gd.showRecordButton()
        }
    }
    
    override func touchBegan(_ touch: UITouch) -> Bool {
        if let gd = gameDelegate {
            if let newState = gd.enterState(MSRecordButtonDownState.self) {
                newState.setTouch(touch)
                return true
            }
        }
        return false
    }
    
}

class MSRecordButtonDownState : MSReplayKitState {
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        if let gd = gameDelegate {
            gd.highlightRecordButton(highlight: true)
        }
    }
    
    override func touchMoved(_ onButton: Bool) -> Bool {
        if let gd = gameDelegate {
            gd.highlightRecordButton(highlight: onButton)
        }
        return true
    }
    override func touchCancelled(_ onButton: Bool) -> Bool {
        if let gd = gameDelegate {
            let _ = gd.enterState(MSWaitRecordState.self)
        }
        return true
    }
    override func touchEnded(_ onButton: Bool) -> Bool {
        if let gd = gameDelegate {
            let _ = gd.enterState(onButton ? MSRecordingState.self : MSWaitRecordState.self)
        }
        return true
    }
    
}

class MSRecordingState : MSReplayKitState {
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        if let gd = gameDelegate {
            gd.highlightStopButton(highlight: false)
            gd.showStopButton()
            gd.startRecording()
        }
    }
    override func touchBegan(_ touch: UITouch) -> Bool {
        if let gd = gameDelegate {
            if let newState = gd.enterState(MSStopButtonDownState.self) {
                newState.setTouch(touch)
                return true
            }
        }
        return false
    }
    
}

class MSStopButtonDownState : MSReplayKitState {
    override func didEnter(from previousState: GKState?) {
        if let gd = gameDelegate {
            gd.highlightStopButton(highlight: true)
        }
    }
    override func touchMoved(_ onButton: Bool) -> Bool {
        if let gd = gameDelegate {
            gd.highlightStopButton(highlight: onButton)
        }
        return true
    }
    override func touchCancelled(_ onButton: Bool) -> Bool {
        if let gd = gameDelegate {
            let _ = gd.enterState(MSRecordingState.self)
        }
        return true
    }
    override func touchEnded(_ onButton: Bool) -> Bool {
        if let gd = gameDelegate {
            let _ = gd.enterState(onButton ? MSPreviewingState.self : MSRecordingState.self)
        }
        return true
    }
    
}

class MSPreviewingState : MSReplayKitState {
    override func didEnter(from previousState: GKState?) {
        if let gd = gameDelegate {
            gd.stopRecording()
            let _ = gd.enterState(MSWaitRecordState.self)
        }
    }
}

