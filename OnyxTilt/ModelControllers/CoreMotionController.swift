//
//  CoreMotionManager.swift
//  OnyxTilt
//
//  Created by DevMountain on 4/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import UIKit.UIImpactFeedbackGenerator
import CoreMotion

protocol CoreMotionControllerDelegate: class {
    func deviceDidEnterSweetSpot()
    func deviceDidExitSweetSpot()
    func deviceDidUpdatePitch()
}

class CoreMotionController {
    
    //MARK: - Properties
    let motionManager = CMMotionManager()
    weak var delegate: CoreMotionControllerDelegate?
    var onSweetSpot: Bool = false
    let hapticGenerator = UIImpactFeedbackGenerator()
    var pitchInRadians: Double = 0{
        didSet{
            if phoneIsProperlyTilted{
                if !onSweetSpot{
                    hapticGenerator.impactOccurred()
                    onSweetSpot = true
                }
                delegate?.deviceDidEnterSweetSpot()
            }else {
                if onSweetSpot {
                    hapticGenerator.impactOccurred()
                    delegate?.deviceDidExitSweetSpot()
                    onSweetSpot = false
                }
            }
        }
    }
    
    
    var pitchInDegrees: Double {
        get {
            return pitchInRadians.convertingRadiansToDegrees()
        }
        set {
            pitchInRadians = newValue.convertingDegreesToRadians()
        }
    }
    
    var phoneIsProperlyTilted: Bool {
        return pitchInDegrees > 65 && pitchInDegrees < 70
    }
    
    func startDeviceMotion() {
        if motionManager.isDeviceMotionAvailable {
            let interval = 1.0 / 60
            motionManager.deviceMotionUpdateInterval = interval
            motionManager.showsDeviceMovementDisplay = true
            motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { (_) in
                if let data = self.motionManager.deviceMotion {
                    self.pitchInRadians = data.attitude.pitch
                    self.delegate?.deviceDidUpdatePitch()
                }
            }
        }
    }
}
