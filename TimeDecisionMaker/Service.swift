//
//  Service.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/7/19.
//

import UIKit

class Service: NSObject {
    
    var fileKeys = ["SUMMARY:", "CREATED:", "STATUS:", "DESCRIPTION:", "UID:", "DTSTART:", "DTEND:"]
    var timezone: String!
    var appointments = [Appointment]()
    
    public func fetchAppointment(resourceFile: String) -> [Appointment] {
       appointments.removeAll()
        var serviceAppointment = Appointment()
        if let path = Bundle.main.path(forResource: resourceFile, ofType: "ics") {
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
        } else {
            print("Failed to load file from app bundle")
        }
        
        return appointments
    }
    
    private func getElementByKey(element: String) -> (String?, String?) {
        var stringWithoutKeyName : String!
        var keyName : String!
        for key in fileKeys {
            if element.contains(key) {
                stringWithoutKeyName = element.matchingStrings(regex: "(?<=\(key)).*").first?[0]
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


extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                    ? nsString.substring(with: result.range(at: $0))
                    : ""
            }
        }
    }
}
