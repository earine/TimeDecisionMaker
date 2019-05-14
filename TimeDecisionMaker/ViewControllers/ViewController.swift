//
//  ViewController.swift
//  TimeDecisionMaker
//
//  Created by Mikhail on 4/24/19.
//

import UIKit
import SBPickerSelector

class ViewController: UIViewController {
    
    public var monthes = DateFormatter().monthSymbols
    private let rd = RDTimeDecisionMaker()
    private let service = Service()
    
    private var daysInMonth = [Date]()
    private var dictionary = [Date : [Appointment]]()
    
    private var initialMonth : String = Date().monthAsString()
    private var initialYear : Int = Date().yearAsString()
    
    public var selectedPerson : Person?
    private var selectedEvent : Appointment?
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateDatesWithEvents()
    }
    
    private func calculateDatesWithEvents() {
        self.navigationItem.title = initialMonth
        daysInMonth = service.getDaysByMonth(month: initialMonth, year: initialYear)
        let events = service.fetchAppointment(resourceFile: selectedPerson?.ICSPath ?? "A")
        dictionary = service.getEventsForSelectedMonth(eventsList: events, monthDates: daysInMonth).0
        daysInMonth.remove(at: daysInMonth.count - 1)
        
    }
    
    
    @IBAction func changeMonth(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: "2019-01")!
        
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.text, data: [monthes!, ["2019", "2020"]], defaultDate: date).cancel {
            print("cancel")
            }.set { values in
                if let values = values as? [String] {
                    self.initialMonth = values[0]
                    self.initialYear = Int(values[1])!
                    self.calculateDatesWithEvents()
                    self.eventsTableView.reloadData()
                }
            }.present(into: self)
       eventsTableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToSingleView") {
            let vc = segue.destination as! SingleAppointmentViewController
            
            vc.selectedEvent = selectedEvent!
        }
    }
    
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return daysInMonth.count
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let key = dictionary[daysInMonth[section]] {
            return key.count
        } else {
            return 0
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath) as! AppointmentTableViewCell
        
        let refIndex = indexPath.section
        let referenceObject = dictionary[daysInMonth[refIndex]]
        let appointment = referenceObject![indexPath.row]
        cell.makeRegularCellStyle()
        if appointment.summary.isEmpty {
            cell.UIforDayWithoutEvents()
            cell.UIforFirstRow(dateValue: appointment.getDayFromDate(date: daysInMonth[refIndex]), weekdayValue: appointment.getWeekDay(date: daysInMonth[refIndex]))
        } else {
            cell.UIforDayWithEvents()
            cell.noEventsLabel.isHidden = true
            cell.summaryLabel.text = appointment.summary
            cell.timeLabel.text = appointment.hoursValueFromDateToString(date: appointment.dateInterval.start)
            cell.durationLabel.text = appointment.durarationToString(dateInterval: appointment.dateInterval)
            
            if indexPath.row == 0 {
                cell.UIforFirstRow(dateValue: appointment.getDayFromDate(date: daysInMonth[refIndex]), weekdayValue: appointment.getWeekDay(date: daysInMonth[refIndex]))
            } else {
                cell.UIforOtherRow()
            }
        }
        
        if indexPath.section == ((Int(appointment.getDayFromDate(date: Date())) ?? 1)-1) && initialMonth == Date().monthAsString() {
            cell.UIforTodayView()
            cell.backgroundColor = UIColor(rgb: 0xe2eff1)
        }
        
        return cell
    }
    
    internal func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return service.getDatesFromMonth(month: daysInMonth)
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let refIndex = indexPath.section
        let referenceObject = dictionary[daysInMonth[refIndex]]
        let appointment = referenceObject![indexPath.row]
        if appointment.dateInterval != nil {
            selectedEvent = appointment
            performSegue(withIdentifier: "goToSingleView", sender: nil)
        } else {
            let alert: UIAlertController = UIAlertController(title: "Oops!", message: "You have no events for this date :(", preferredStyle: .alert)
            
            let okAction: UIAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}

