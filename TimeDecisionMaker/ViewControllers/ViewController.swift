//
//  ViewController.swift
//  TimeDecisionMaker
//
//  Created by Mikhail on 4/24/19.
//

import UIKit

class ViewController: UIViewController {

    let rd = RDTimeDecisionMaker()
    let service = Service()
    var organizerEvents = [Appointment]()
    var attendeeEvents = [Appointment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      let minute: TimeInterval = 3600.0
        organizerEvents = service.fetchAppointment(resourceFile: "A")
       
        attendeeEvents = service.fetchAppointment(resourceFile: "B")
        var a = rd.suggestAppointments(organizerICS: "A", attendeeICS: "B", duration: minute)
        print(a)
    }


}


