//
//  GameDelegate.swift
//  ReplayKitDemo
//
//  Created by Stephen Brennan on 8/18/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import UIKit

protocol GameDelegate : class {
    // UI updates
    func showRecordButton()
    func showStopButton()
    func highlightRecordButton(highlight: Bool)
    func highlightStopButton(highlight: Bool)
    // state changes
    func enterState(_ state: MSReplayKitState.Type) -> MSReplayKitState?
    // recorder control
    func startRecording()
    func stopRecording()
}


