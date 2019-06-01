//
//  Service.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/7/19.
//

import UIKit

class Service: NSObject {
    
    private var fileKeys = ["SUMMARY", "CREATED", "STATUS", "DESCRIPTION", "UID", "DTSTART", "DTEND", "LAST-MODIFIED", "LOCATION", "SEQUENCE", "TRANSP", "DTSTAMP"]
    private var timezone: String!
    private var appointments = [Appointment]()
    private let formatter = DateFormatter()
    
    /// Method for reading .ics file and fetching data from it
    ///
    /// - Parameter resourceFile: .ics file name
    /// - Returns: array of appointments 
    public func fetchAppointment(resourceFile: String) -> [Appointment] {
        appointments.removeAll()
        var serviceAppointment = Appointment()
        guard let path = Bundle.main.path(forResource: resourceFile, ofType: "ics") else {
            print("Failed to load file from app bundle")
            return []
        }
        do {
            var myStrings = try String(contentsOfFile: path, encoding: String.Encoding.utf8).components(separatedBy: .newlines)
            var state = false
            myStrings = myStrings.filter({ $0 != ""})
            for element in myStrings {
                
                if element == "BEGIN:VEVENT" {
                    state = true
                } else if element == "END:VEVENT" {
                    state = false
                    serviceAppointment.makeModelEmptyForChecking()
                } else if element.contains("X-WR-TIMEZONE:") {
                    timezone = element.matchingStrings(regex: "(?<=X-WR-TIMEZONE:).*").first?[0]
                }
                
                if state && getElementByKey(element: element).1 != nil {
                    
                    getVariableByKey(key: getElementByKey(element: element).0!, keyValue: getElementByKey(element: element).1!, thisAppointment: serviceAppointment)
                    
                    if serviceAppointment.isReadyToAdd() {
                        appointments.append(Appointment(summary: serviceAppointment.summary, created: serviceAppointment.created, UID: serviceAppointment.UID, status: serviceAppointment.status, description: serviceAppointment.descriptionAp, dateStart: serviceAppointment.dateStart, dateEnd: serviceAppointment.dateEnd, lastModified: serviceAppointment.lastModified, location: serviceAppointment.location, sequence: serviceAppointment.sequence, transparency: serviceAppointment.transparency, stamp: serviceAppointment.stamp))
                    }
                }
            }
        } catch {
            print("Failed to read text")
        }
        
        return appointments
    }
    
    /// Method to perform saving data to .ics file
    ///
    /// - Parameters:
    ///   - object: edited appointment to save
    ///   - resourceFile: name of .ics file to update
    /// - Returns: return true if saved successfuly, false — if there is an error
    public func saveEditedObjectToICSFile(object: Appointment, resourceFile: String) -> Bool{
        var serviceAppointment = Appointment()
        var newStrings = [String]()
        formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let path = Bundle.main.path(forResource: resourceFile, ofType: "ics") else {
            print("Failed to load file from app bundle")
            return false
        }
        do {
            var myStrings = try String(contentsOfFile: path, encoding: String.Encoding.utf8).components(separatedBy: .newlines)
            var state = true
            myStrings = myStrings.filter({ $0 != ""})
            for i in 0..<myStrings.count {
                
                if myStrings[i] == "BEGIN:VEVENT" && myStrings[i+4] == "UID:\(object.UID)"{
                    print("UID:\(object.UID)")
                    newStrings.append(myStrings[i])
                    newStrings.append("DTSTART:\(formatter.string(from: object.dateInterval.start))")
                    newStrings.append("DTEND:\(formatter.string(from: object.dateInterval.end))")
                    newStrings.append("DTSTAMP:\(formatter.string(from: object.stamp))")
                    newStrings.append("UID:\(object.UID)")
                    newStrings.append("CREATED:\(formatter.string(from: object.created))")
                    newStrings.append("DESCRIPTION:\(object.descriptionAp ?? "")")
                    newStrings.append("LAST-MODIFIED:\(formatter.string(from: object.lastModified))")
                    newStrings.append("LOCATION:\(object.location)")
                    newStrings.append("SEQUENCE:\(object.sequence ?? 0)")
                    newStrings.append("STATUS:\(object.status.description)")
                    newStrings.append("SUMMARY:\(object.summary)")
                    newStrings.append("TRANSP:\(object.transparency.description)")
                    state = false
                } else if !state && myStrings[i] == "END:VEVENT" {
                    state = true
                }
                
                if state {
                    newStrings.append(myStrings[i])
                }
            }
            
            let joined = newStrings.joined(separator: ("\n"))
            do {
                try joined.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                // handle error
            }

        } catch {
            print("Failed to read text")
            return false
        }
        
        return true
    }
    
    /// Method for finding appointments for selected month
    ///
    /// - Parameters:
    ///   - eventsList: array of all appointments
    ///   - monthDates: array of month's dates
    /// - Returns: dictinary - key as dates, values as arrays of appointments
    public func getEventsForSelectedMonth(eventsList: [Appointment], monthDates: [Date]) -> [Date: [Appointment]] {
        var allEventsForSelectedMonth = [Appointment]()
        var events = [Date: [Appointment]]()
        let emptyAppointment = Appointment()
        
        let selectedMonthInterval = DateInterval(start: monthDates.first!, end: monthDates.last!)
        
        for event in eventsList {
            if selectedMonthInterval.contains(event.dateInterval.start) {
                allEventsForSelectedMonth.append(event)
            }
        }
        
        let sortedEvents = allEventsForSelectedMonth.sorted(by: { $0.dateInterval.start < $1.dateInterval.start})
        
        for date in monthDates {
            for event in sortedEvents {
                if events[date] != nil {
                    if DateInterval(start: date, duration: 86340).contains(event.dateInterval.start) {
                        events[date]?.append(event)
                    }
                } else {
                    if DateInterval(start: date, duration: 86340).contains(event.dateInterval.start) {
                        events[date] = [event]
                    }
                }
            }
        }
        for date in monthDates {
            if events[date] == nil {
                events[date] = [emptyAppointment]
            }
        }
        return events
    }
    
    /// Method for extacting values from a line without key
    ///
    /// - Parameter element: line from .ics file
    /// - Returns: value with key
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
    
    /// Method for saving values to the appointment
    ///
    /// - Parameters:
    ///   - key: title of the key from .ics file such as "SUMMARY"
    ///   - keyValue: values of this key
    ///   - thisAppointment: current object to perform
    private func getVariableByKey(key: String, keyValue: String, thisAppointment: Appointment) {
        switch key {
        case fileKeys[0]:
            thisAppointment.summary = keyValue
        case fileKeys[1]:
            thisAppointment.created = keyValue.convertStringToDate(timezone: timezone, format: "yyyyMMdd'T'HHmmss'Z'")
        case fileKeys[2]:
            thisAppointment.status = thisAppointment.statusTypeFromString(value: keyValue)
        case fileKeys[3]:
            thisAppointment.descriptionAp = keyValue
        case fileKeys[4]:
            thisAppointment.UID = keyValue
        case fileKeys[5]:
            thisAppointment.dateStart = keyValue.convertStringToDate(timezone: timezone, format: "yyyyMMdd'T'HHmmss'Z'")
        case fileKeys[6]:
            thisAppointment.dateEnd = keyValue.convertStringToDate(timezone: timezone, format: "yyyyMMdd'T'HHmmss'Z'")
        case fileKeys[7]:
            thisAppointment.lastModified = keyValue.convertStringToDate(timezone: timezone, format: "yyyyMMdd'T'HHmmss'Z'")
        case fileKeys[8]:
            thisAppointment.location = keyValue
        case fileKeys[9]:
            thisAppointment.sequence = Int(keyValue) ?? 0
        case fileKeys[10]:
            thisAppointment.transparency = thisAppointment.transparencyTypeFromString(value: keyValue)
        case fileKeys[11]:
            thisAppointment.stamp = keyValue.convertStringToDate(timezone: timezone, format: "yyyyMMdd'T'HHmmss'Z'")
        default:
            print("error")
        }
        
    }
    
    /// Method to perform days in the month calculation
    ///
    /// - Parameters:
    ///   - month: selected month's name
    ///   - year: selected year
    /// - Returns: array of dates in the month
    public func getDaysByMonth(month: String, year: Int) -> [Date] {
        let calendar = Calendar.current
        
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
    
    /// Method to perform days calculation from 1 to month's lenghth
    ///
    /// - Parameter month: selected month's name
    /// - Returns: array of strings
    public func getDatesFromMonth(month: [Date]) -> [String] {
        var values = [String]()
        for i in 1...month.count {
            values.append("\(i)")
        }
        return values
    }
    
    /// Method for checking if date interval is ready for manipulations
    ///
    /// - Parameters:
    ///   - startDate: start date
    ///   - endDate: end date
    /// - Returns: returns true if dates are ready for date interval type
    public func dateViladation(startDate: Date, endDate: Date) -> Bool {
        guard startDate < endDate  else {
            return false
        }
        return true
    }
}


