//
//  DoubleExtension.swift
//  OnyxTilt
//
//  Created by DevMountain on 4/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation

extension Double {
    func convertingRadiansToDegrees() -> Double{
        return (180 / Double.pi) * self
    }
    
    func convertingDegreesToRadians() -> Double {
        return (Double.pi / 180) * self
    }
}
