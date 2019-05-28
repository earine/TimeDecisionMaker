//
//  CalculateAppointmentViewController.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/24/19.
//

import UIKit

class CalculateAppointmentViewController: UIViewController {
    
    public var people = [Person]()
    private var firstSelectedPerson = Person()
    private var secondSelectedPerson = Person()
    
    @IBOutlet weak var firstPersonTextField: UITextField!
    @IBOutlet weak var secondPersonTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    
    @IBOutlet weak var durationPicker: UIDatePicker!
    @IBOutlet weak var personPicker: UIPickerView!
    @IBOutlet weak var secondPersonPicker: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        firstPersonTextField.text = "None"
        showPickerView(check: false, picker: personPicker)
        showPickerView(check: false, picker: secondPersonPicker)
    }

    private func showPickerView(check: Bool, picker: UIPickerView) {
        doneButton.isHidden = !check
        cancelButton.isHidden = !check
        picker.isHidden = !check
    }
    
    private func showDurationPickerView(check: Bool) {
        doneButton.isHidden = !check
        cancelButton.isHidden = !check
        durationPicker.isHidden = !check
    }
    
    
    @IBAction func firstPersonTapped(_ sender: Any) {
        showPickerView(check: false, picker: secondPersonPicker)
        showPickerView(check: true, picker: personPicker)
    }
    
    @IBAction func secondPersonTapped(_ sender: Any) {
        showPickerView(check: false, picker: personPicker)
        showPickerView(check: true, picker: secondPersonPicker)
    }
    
    @IBAction func durationPicked(_ sender: Any) {
        showDurationPickerView(check: true)
        durationTextField.text = durationPicker.countDownDuration.toString()
    }
    
    // Cancel button
    @IBAction func cancelButtonClicked(sender: UIButton) {
        showPickerView(check: false, picker: personPicker)
        showPickerView(check: false, picker: secondPersonPicker)
    }
    
    
    @IBAction func doneButtonClicked(sender: UIButton) {
        showPickerView(check: false, picker: personPicker)
        showPickerView(check: false, picker: secondPersonPicker)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if firstPersonTextField.text != secondPersonTextField.text {
            performSegue(withIdentifier: "goToFreeSlots", sender: nil)
        } else {
            let alert: UIAlertController = UIAlertController(title: "Error!", message: "The same person is choosed!", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToFreeSlots") {
            let vc = segue.destination as! FreeSlotsTableViewController
            
            vc.firstPerson = firstSelectedPerson
            vc.secondPerson = secondSelectedPerson
        }
    }
}

extension CalculateAppointmentViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return people.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == personPicker {
            firstSelectedPerson = people[row]
            firstPersonTextField.text = people[row].name
        } else if pickerView == secondPersonPicker {
            secondSelectedPerson = people[row]
            secondPersonTextField.text = people[row].name
        }
        return people[row].name
    }
}

