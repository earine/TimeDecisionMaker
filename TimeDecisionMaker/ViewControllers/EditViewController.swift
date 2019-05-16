//
//  EditViewController.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/15/19.
//

import UIKit

class EditViewController: UIViewController {
    
    public var selectedEvent = Appointment()
    
    private var formatter = DateFormatter()
    private let datePicker = UIDatePicker()
    
    @IBOutlet weak var dateStartTextfield: UITextField!
    @IBOutlet weak var dateEndTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    
    private func updateUI() {
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        dateStartTextfield.text = formatter.string(from: selectedEvent.dateInterval.start)
        dateEndTextfield.text = formatter.string(from: selectedEvent.dateInterval.end)
        
        datePicker.datePickerMode = .dateAndTime
        addToolBar(dateTextfield: dateStartTextfield, datePicker: datePicker)
        addToolBar(dateTextfield: dateEndTextfield, datePicker: datePicker)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        Service().saveEditedObjectToICSFile(object: selectedEvent, resourceFile: "A")
    }
    
    
    private func addToolBar(dateTextfield: UITextField, datePicker: UIDatePicker) {
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        var doneButton = UIBarButtonItem()
        if dateTextfield == dateStartTextfield {
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStartDatePicker));
        } else if dateTextfield == dateEndTextfield {
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEndDatePicker));
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateTextfield.inputAccessoryView = toolbar
        dateTextfield.inputView = datePicker
    }
    
    @objc func doneStartDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if datePicker.date < selectedEvent.dateInterval.end {
            selectedEvent.dateInterval.start = datePicker.date
            dateStartTextfield.text = formatter.string(from: datePicker.date)
        } else {
            let alert: UIAlertController = UIAlertController(title: "Error!", message: "Event's start date cannot be later than  event's end date!", preferredStyle: .alert)
            
            let okAction: UIAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        self.view.endEditing(true)
    }
    
    @objc func doneEndDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if datePicker.date > selectedEvent.dateInterval.start {
            selectedEvent.dateInterval.end = datePicker.date
            dateEndTextfield.text = formatter.string(from: datePicker.date)
        } else {
            let alert: UIAlertController = UIAlertController(title: "Error!", message: "Event's end date cannot be earlier than  event's start date!", preferredStyle: .alert)
            
            let okAction: UIAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    
}

