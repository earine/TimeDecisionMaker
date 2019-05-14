//
//  SingleAppointmentViewController.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/13/19.
//

import UIKit

class SingleAppointmentViewController: UIViewController {

    @IBOutlet weak var timeStartLabel: UILabel!
    @IBOutlet weak var timeEndLabel: UILabel!
    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var dateEndLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var selectedEvent = Appointment()
    
    override func viewDidLoad() {
        super.viewDidLoad()
updateEventUI()
        // Do any additional setup after loading the view.
    }
    
    private func updateEventUI() {
        navigationItem.title = selectedEvent.summary
        timeStartLabel.text = selectedEvent.hoursValueFromDateToString(date: selectedEvent.dateInterval.start)
        timeEndLabel.text = selectedEvent.hoursValueFromDateToString(date: selectedEvent.dateInterval.end)
        dateStartLabel.text = "\(selectedEvent.dateInterval.start.monthAsString()) \(selectedEvent.dateInterval.start.dayAsString())"
         dateEndLabel.text = "\(selectedEvent.dateInterval.end.monthAsString()) \(selectedEvent.dateInterval.end.dayAsString())"
        statusLabel.text = selectedEvent.status.description 
    }
   

}
