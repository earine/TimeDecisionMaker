//
//  TimeIntervalExtension.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/14/19.
//

import Foundation

extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: self)
    }
    
    func toString() -> String {
        if self.format(using: [.minute]) == "0m"{
            return self.format(using: [.hour]) ?? ""
        } else {
            return self.format(using: [.hour, .minute]) ?? ""
        }
    }
}
