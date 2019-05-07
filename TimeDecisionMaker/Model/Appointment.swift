//
//  Appointment.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/7/19.
//

import Foundation

class Appointment : NSObject {
    
    public var summary : String = ""
    public var location : String = ""
 
    func isReadyToAdd() -> Bool {
        return summary.count > 0  && location.count > 0  
    }
    
    override init() {
        self.summary = ""
        self.location  = ""
    }
     init(summary: String, location: String) {
        self.summary = summary
        self.location = location
    }
}
