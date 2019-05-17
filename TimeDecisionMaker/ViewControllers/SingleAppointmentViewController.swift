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
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionCaptionLabel: UILabel!
    
    public var selectedEvent = Appointment()
    public var selectedPerson: Person?
    
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
        statusLabel.text = selectedEvent.status.description.capitalized
        
        if selectedEvent.descriptionAp != "" {
            descriptionCaptionLabel.text = selectedEvent.descriptionAp
            descriptionLabel.isHidden = false
            descriptionCaptionLabel.isHidden = false
        } else {
            descriptionCaptionLabel.isHidden = true
            descriptionLabel.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToEditView") {
            let vc = segue.destination as! EditViewController
            vc.selectedPerson = selectedPerson
            vc.selectedEvent = selectedEvent
        }
    }
    
}
