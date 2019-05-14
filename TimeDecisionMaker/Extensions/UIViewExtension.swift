//
//  UIViewExtension.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/14/19.
//

import Foundation
import UIKit

extension UIView {

    public var cornerRadiusRatio: CGFloat {
        get {
            return layer.cornerRadius / frame.width
        }
        set {
            let normalizedRatio = max(0.0, min(1.0, newValue))
            layer.cornerRadius = frame.width * normalizedRatio
        }
    }
    
}
