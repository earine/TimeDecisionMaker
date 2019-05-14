//
//  Service.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/7/19.
//

import UIKit

class Service: NSObject {
    
    private var fileKeys = ["SUMMARY", "CREATED", "STATUS", "DESCRIPTION", "UID", "DTSTART", "DTEND"]
    private var timezone: String!
    var appointments = [Appointment]()
    
    public func fetchAppointment(resourceFile: String) -> [Appointment] {
        appointments.removeAll()
        var serviceAppointment = Appointment()
        guard let path = Bundle.main.path(forResource: resourceFile, ofType: "ics") else {
            print("Failed to load file from app bundle")
            return []
        }
        do {
            let myStrings = try String(contentsOfFile: path, encoding: String.Encoding.utf8).components(separatedBy: .newlines)
            var state = false
            
            for element in myStrings {
                
                if element == "BEGIN:VEVENT" {
                    state = true
                } else if element == "END:VEVENT" {
                    state = false
                    serviceAppointment.makeModelEmptyForChecking()
                } else if element.contains("X-WR-TIMEZONE:") {
                    timezone = element.matchingStrings(regex: "(?<=X-WR-TIMEZONE:).*").first?[0]
                }
                
                if state {
                    
                    if getElementByKey(element: element).1 != nil {
                        
                        getVariableByKey(key: getElementByKey(element: element).0!, keyValue: getElementByKey(element: element).1!, thisAppointment: serviceAppointment)
                        
                        if serviceAppointment.isReadyToAdd() {
                            appointments.append(Appointment(summary: serviceAppointment.summary, created: serviceAppointment.created, UID: serviceAppointment.UID, status: serviceAppointment.status, description: serviceAppointment.description, dateStart: serviceAppointment.dateStart, dateEnd: serviceAppointment.dateEnd))
                        }
                    }
                }
            }
        } catch {
            print("Failed to read text")
        }
        
        return appointments
        
    }
    
    public func getEventsForSelectedMonth(eventsList: [Appointment], monthDates: [Date]) -> ([Date: [Appointment]], [Appointment]) {
        var eventsForSelectedMonth = [Appointment]()
        var ev = [Date: [Appointment]]()
        let emptyAppointment = Appointment()
        
        let selectedMonthInterval = DateInterval(start: monthDates.first!, end: monthDates.last!)

        for event in eventsList {
            if selectedMonthInterval.contains(event.dateInterval.start) {
                eventsForSelectedMonth.append(event)
            }
        }
        
        let sortedEvents = eventsForSelectedMonth.sorted(by: { $0.dateInterval.start < $1.dateInterval.start})
        
        for date in monthDates {
            for event in sortedEvents {
                if ev[date] != nil {
                    if DateInterval(start: date, duration: 86340).contains(event.dateInterval.start) {
                        ev[date]?.append(event)
                    }
                } else {
                    if DateInterval(start: date, duration: 86340).contains(event.dateInterval.start) {
                        ev[date] = [event]
                    }
                }
            }
        }
        for date in monthDates {
                if ev[date] == nil {
                    ev[date] = [emptyAppointment]
                }
        }
        return (ev, sortedEvents)
    }
    
    public func getDaysByMonth(month: String, year: Int) -> [Date] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM"
        
        formatter.timeZone = TimeZone(identifier: "Europe/Kiev")
        let components = calendar.dateComponents([.year, .month], from: formatter.date(from: "\(year)-\(month)")!)
        let startOfMonth = calendar.date(from: components)!
        let numberOfDays = calendar.range(of: .day, in: .month, for: startOfMonth)!.upperBound
        let allDays = Array(0..<numberOfDays).map{ calendar.date(byAdding:.day, value: $0, to: startOfMonth)!}
        var dates = [Date]()
        for date in allDays {
            dates.append(date.convertToTimeZone(initTimeZone:TimeZone(abbreviation: "UTC")!, timeZone: TimeZone(identifier: "Europe/Kiev")!))
        }
        return dates
    }
    
    public func getDatesFromMonth(month: [Date]) -> [String] {
        var values = [String]()
        for i in 1...month.count {
            values.append("\(i)")
        }
        return values
    }
    
    private func getElementByKey(element: String) -> (String?, String?) {
        var stringWithoutKeyName : String!
        var keyName : String!
        for key in fileKeys {
            if element.contains(key) {
                if element.contains("\(key);VALUE=DATE:") {
                    if let value = element.matchingStrings(regex: "(?<=\(key);VALUE=DATE:).*").first?[0] {
                        stringWithoutKeyName = "\(value)T000000Z"
                    }
                } else {
                    stringWithoutKeyName = element.matchingStrings(regex: "(?<=\(key):).*").first?[0]
                }
                keyName = key
            }
        }
        return (keyName, stringWithoutKeyName)
    }
    
    private func getVariableByKey(key: String, keyValue: String, thisAppointment: Appointment) {
        switch key {
        case fileKeys[0]:
            thisAppointment.summary = keyValue
        case fileKeys[1]:
            thisAppointment.created = thisAppointment.convertStringToDate(value: keyValue, timezone: timezone)
        case fileKeys[2]:
            thisAppointment.status = thisAppointment.typeFromString(value: keyValue)
        case fileKeys[3]:
            thisAppointment.descriptionAp = keyValue
        case fileKeys[4]:
            thisAppointment.UID = keyValue
        case fileKeys[5]:
            thisAppointment.dateStart = thisAppointment.convertStringToDate(value: keyValue, timezone: timezone)
        case fileKeys[6]:
            thisAppointment.dateEnd = thisAppointment.convertStringToDate(value: keyValue, timezone: timezone)
        default:
            print("error")
        }
        
    }
}


