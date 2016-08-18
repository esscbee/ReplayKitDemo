//
//  GameViewController.swift
//  ReplayKitDemo
//
//  Created by Stephen Brennan on 8/17/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import ReplayKit

class GameViewController: UIViewController, RPPreviewViewControllerDelegate, RecorderDelegate {
    
    
    
    func startRecording() {
        let recorder = RPScreenRecorder.shared()
        
        recorder.startRecording(handler: { (error) in
            if let unwrappedError = error {
                print("Start Recording: ", unwrappedError.localizedDescription)
            }
        })
    }
    
    func stopRecording() {
        let recorder = RPScreenRecorder.shared()
        
        recorder.stopRecording(handler:  { [unowned self] (preview, error) in
            if let unwrappedPreview = preview {
                unwrappedPreview.previewControllerDelegate = self
                self.present(unwrappedPreview, animated: true, completion: nil)
            }
        })
    }
    
    func previewControllerDidFinish(previewController: RPPreviewViewController) {
        dismiss(animated: true, completion: nil)
    }

override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.setRecorderDelegate(self)
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
