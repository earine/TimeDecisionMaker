//
//  ViewController.swift
//  TimeDecisionMaker
//
//  Created by Mikhail on 4/24/19.
//

import UIKit

class ViewController: UIViewController {

    let service = Service()
    var organizerEvents = [Appointment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        organizerEvents = service.fetchAppointment(resourceFile: "A")
        var i = 1
        for org in organizerEvents {
            print("#\(i) \(org.summary) — \(org.location)")
            i += 1
        }
    }


}


