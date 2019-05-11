//
//  ViewController.swift
//  TimeDecisionMaker
//
//  Created by Mikhail on 4/24/19.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let formatter = DateFormatter()
    public var monthes = DateFormatter().monthSymbols
    public var daysInMonth = [Date]()
    private let rd = RDTimeDecisionMaker()
    private let service = Service()
    private var organizerEvents = [Appointment]()
    private var attendeeEvents = [Appointment]()
    private var dictionary = [Date : [Appointment]]()
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateDatesWithEvents()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return daysInMonth.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let key = dictionary[daysInMonth[section]] {
            return key.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath) as! AppointmentTableViewCell
        let refIndex = indexPath.section
        
        let referenceObject = dictionary[daysInMonth[refIndex]]
    
        let appointment = referenceObject![indexPath.row]
        
        if appointment.summary.isEmpty {
            cell.UIforDayWithoutEvents()
            cell.UIforFirstRow(dateValue: appointment.getDayFromDate(date: daysInMonth[refIndex]), weekdayValue: appointment.getWeekDay(date: daysInMonth[refIndex]))
            cell.noEventsLabel.text = "No events for today :("
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
        
        return cell
    }
    
    
    
    func calculateDatesWithEvents() {
        daysInMonth = service.getDaysByMonth(month: 4, year: 2019)
        var events = service.fetchAppointment(resourceFile: "A")
        for e in events {
            print(e.dateInterval)
        }
//        organizerEvents = service.getEventsForSelectedMonth(eventsList: s).1
      
        dictionary = service.getEventsForSelectedMonth(eventsList: events, monthDates: daysInMonth).0
//        print(dictionary[daysInMonth[0]])

       
        
        daysInMonth.remove(at: daysInMonth.count - 1)
    }

}



