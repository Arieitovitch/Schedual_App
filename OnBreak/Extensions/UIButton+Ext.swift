//
//  UIButton+Ext.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-13.
//

import UIKit

extension UIButton {

        func pulsate() {

            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.duration = 0.2
            pulse.fromValue = 0.95
            pulse.toValue = 1.0
            pulse.autoreverses = true
            pulse.repeatCount = 0
            pulse.initialVelocity = 0.5
            pulse.damping = 1.0

            layer.add(pulse, forKey: "pulse")
        }


        func shake() {

            let shake = CABasicAnimation(keyPath: "position")
            shake.duration = 0.05
            shake.repeatCount = 3
            shake.autoreverses = true

            let fromPoint = CGPoint(x: center.x - 5, y: center.y)
            let fromValue = NSValue(cgPoint: fromPoint)

            let toPoint = CGPoint(x: center.x + 5, y: center.y)
            let toValue = NSValue(cgPoint: toPoint)

            shake.fromValue = fromValue
            shake.toValue = toValue

            layer.add(shake, forKey: "position")
        }
    }
