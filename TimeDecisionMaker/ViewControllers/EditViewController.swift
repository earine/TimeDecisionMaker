//
//  EditViewController.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/15/19.
//

import UIKit

class EditViewController: UIViewController {
    
    public var selectedEvent = Appointment()
    public var selectedPerson: Person?
    
    private var formatter = DateFormatter()
  
    
    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var dateEndLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var durationPicker: UIDatePicker!
    @IBOutlet weak var dateStartPicker: UIDatePicker!
    @IBOutlet weak var dateEndPicker: UIDatePicker!
    @IBOutlet weak var doneStartButton: UIButton!
    @IBOutlet weak var doneEndButton: UIButton!
    @IBOutlet weak var doneDurationButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         formatter.dateFormat = "dd/MM/yyyy HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        updateUI()
       
    }
    
    private func updateUI() {
       
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        dateStartLabel.text = formatter.string(from: selectedEvent.dateInterval.start)
        dateEndLabel.text = formatter.string(from: selectedEvent.dateInterval.end)
        durationLabel.text = selectedEvent.dateInterval.duration.toString()
        
        dateStartPicker.timeZone = TimeZone(abbreviation: "UTC")
        dateEndPicker.timeZone = TimeZone(abbreviation: "UTC")
        
        showPickerView(check: false, picker: dateStartPicker, doneButton: doneStartButton)
        showPickerView(check: false, picker: dateEndPicker, doneButton: doneEndButton)
        showPickerView(check: false, picker: durationPicker, doneButton: doneDurationButton)
    }
    
    private func showPickerView(check: Bool, picker: UIDatePicker, doneButton: UIButton) {
        doneButton.isHidden = !check
        cancelButton.isHidden = !check
        picker.isHidden = !check
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if Service().dateViladation(startDate: dateStartLabel.text!.convertStringToDate(timezone: "Europe/Kiev", format: "dd/MM/yyyy HH:mm"), endDate:  dateEndLabel.text!.convertStringToDate(timezone: "Europe/Kiev", format: "dd/MM/yyyy HH:mm")) {
            
            selectedEvent.dateInterval.start = dateStartLabel.text!.convertStringToDate(timezone: "Europe/Kiev", format: "dd/MM/yyyy HH:mm")
            selectedEvent.dateInterval.end =  dateEndLabel.text!.convertStringToDate(timezone: "Europe/Kiev", format: "dd/MM/yyyy HH:mm")
            
            if Service().saveEditedObjectToICSFile(object: selectedEvent, resourceFile: selectedPerson?.ICSPath ?? "A") {
                
                self.present(Alert().showAlert(titleText: "Saved!", messageText: "Everything is saved. New information will be available after reopening list with the appointments"), animated: true, completion: nil)
                
            } else {
                
                self.present(Alert().showAlert(titleText: "Error!", messageText: "File cannot be edited :("), animated: true, completion: nil)
            }
        } else {
            self.present(Alert().showAlert(titleText: "Error!", messageText: "Event's start date cannot be later than  event's end date!"), animated: true, completion: nil)
        }
    }
    
    
    
}

extension EditViewController {
    
    @IBAction func dateStartPicked(_ sender: Any) {
        showPickerView(check: true, picker: dateStartPicker, doneButton: doneStartButton)
    }
    
    @IBAction func doneStartButton(sender: UIButton) {
        dateStartLabel.text = formatter.string(from: dateStartPicker.date)
        if Service().dateViladation(startDate: dateStartLabel.text!.convertStringToDate(timezone: "Europe/Kiev", format: "dd/MM/yyyy HH:mm"), endDate: dateEndLabel.text!.convertStringToDate(timezone: "Europe/Kiev", format: "dd/MM/yyyy HH:mm")) {
            
            durationLabel.text = "\(DateInterval(start: dateStartLabel.text!.convertStringToDate(timezone: "Europe/Kiev", format: "dd/MM/yyyy HH:mm"), end: dateEndLabel.text!.convertStringToDate(timezone: "Europe/Kiev", format: "dd/MM/yyyy HH:mm")).duration.toString())"
            
        } else {
            durationLabel.text = "0h"
        }
         showPickerView(check: false, picker: dateStartPicker, doneButton: doneStartButton)
    }
    
    @IBAction func dateEndPicked(_ sender: Any) {
        showPickerView(check: true, picker: dateEndPicker, doneButton: doneEndButton)
    }
    
    @IBAction func doneEndButton(sender: UIButton) {
        dateEndLabel.text = formatter.string(from: dateEndPicker.date)
        if Service().dateViladation(startDate: dateStartLabel.text!.convertStringToDate(timezone: "Europe/Kiev", format: "dd/MM/yyyy HH:mm"), endDate: dateEndLabel.text!.convertStringToDate(timezone: "Europe/Kiev", format: "dd/MM/yyyy HH:mm")) {
            
            durationLabel.text = "\(DateInterval(start: dateStartLabel.text!.convertStringToDate(timezone: "Europe/Kiev", format: "dd/MM/yyyy HH:mm"), end: dateEndLabel.text!.convertStringToDate(timezone: "Europe/Kiev", format: "dd/MM/yyyy HH:mm")).duration.toString())"
            
        } else {
            durationLabel.text = "0h"
        }
        showPickerView(check: false, picker: dateEndPicker, doneButton: doneEndButton)
    }
    
    @IBAction func durationPicked(_ sender: Any) {
        showPickerView(check: true, picker: durationPicker, doneButton: doneDurationButton)
    }
    
    @IBAction func doneDurationButtonClicked(sender: UIButton) {
        durationLabel.text = durationPicker.countDownDuration.toString()
        dateEndLabel.text = formatter.string(from: DateInterval(start:  dateStartLabel.text!.convertStringToDate(timezone: "Europe/Kiev", format: "dd/MM/yyyy HH:mm"), duration: durationPicker.countDownDuration).end)
        showPickerView(check: false, picker: durationPicker, doneButton: doneDurationButton)
    }
    
    @IBAction func cancelButtonClicked(sender: UIButton) {
        showPickerView(check: false, picker: dateStartPicker, doneButton: doneStartButton)
        showPickerView(check: false, picker: dateEndPicker, doneButton: doneEndButton)
        showPickerView(check: false, picker: durationPicker, doneButton: doneDurationButton)
    }
}
