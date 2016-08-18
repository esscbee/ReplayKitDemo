//
//  GameScene.swift
//  ReplayKitDemo
//
//  Created by Stephen Brennan on 8/17/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol GameDelegate : class {
    func showRecordButton()
    func showStopButton()
}

class MSReplayKitState : GKState {
    var gameDelegate : GameDelegate
    init(gameDelegate: GameDelegate) {
        self.gameDelegate = gameDelegate
    }
    
}

class MSWaitRecordState : MSReplayKitState {
    
}

class MSRecordButtonDownState : MSReplayKitState {
    
}

class MSRecordingState : MSReplayKitState {
    
}

class MSStopButtonDownState : MSReplayKitState {
    
}

class MSPreviewingState : MSReplayKitState {
    
}

class GameScene: SKScene, GameDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var stopButton : SKShapeNode?
    private var recordButton : SKShapeNode?
    
    private var stateMachine : GKStateMachine!
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        // create record / stop buttons
        
        let recordRadius = frame.width / 12.0
        let bottomY = frame.midY - frame.height / 2.0
        self.recordButton = SKShapeNode(circleOfRadius: recordRadius)
        if let recordButton = self.recordButton {
            recordButton.position = CGPoint(x:frame.midX, y:bottomY + 2 * recordRadius)
            recordButton.fillColor = UIColor.red
            recordButton.strokeColor = UIColor.black
            recordButton.alpha = 0.0
            self.addChild(recordButton)
            
            let cornerRadius : CGFloat = 10.0

            self.stopButton = SKShapeNode(rectOf: CGSize(width: recordRadius * 2.0, height: recordRadius * 2.0), cornerRadius: cornerRadius)
            if let stopButton = self.stopButton {
                stopButton.position = recordButton.position
                stopButton.fillColor = UIColor.darkGray
                self.addChild(stopButton)
                let sub = SKShapeNode(rectOf: CGSize(width: recordRadius, height: recordRadius), cornerRadius: cornerRadius)
                sub.fillColor = UIColor.lightGray
                stopButton.addChild(sub)
                stopButton.alpha = 0.0
            }
        }
        // initialize state machine
        
    }
    
    func showButtons(record: Bool, stop: Bool) {
        if let rb = recordButton {
            rb.alpha = record ? 1.0 : 0.0
        }
        if let sb = stopButton {
            sb.alpha = stop ? 1.0 : 0.0
        }
    }
    
    func showStopButton() {
        showButtons(record: false, stop: true)
    }
    func showRecordButton() {
        showButtons(record: true, stop: false)
    }
    
    func initStateMachine() {
        self.stateMachine = GKStateMachine(states: [
            MSWaitRecordState(gameDelegate: self),
            MSRecordButtonDownState(gameDelegate: self),
            MSRecordingState(gameDelegate: self),
            MSStopButtonDownState(gameDelegate: self),
            MSPreviewingState(gameDelegate: self),
            
            ])
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            print(pos)
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
