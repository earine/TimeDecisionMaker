//
//  Person.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/12/19.
//

import UIKit

class Person: NSObject {
    
    public var name : String = ""
    public var ICSPath : String = ""
  
    
    init(name: String, ICSPath: String) {
        self.name = name
        self.ICSPath = ICSPath
    }
    
}
