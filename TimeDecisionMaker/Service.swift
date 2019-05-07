//
//  Service.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/7/19.
//

import UIKit

class Service: NSObject {
    
    var fileKeys = ["SUMMARY:", "CREATED:"]
    var serviceAppointment = Appointment()
    var appointments = [Appointment]()
    
    public func fetchAppointment(resourceFile: String) -> [Appointment] {
        
        if let path = Bundle.main.path(forResource: resourceFile, ofType: "ics") {
            do {
                let myStrings = try String(contentsOfFile: path, encoding: String.Encoding.utf8).components(separatedBy: .newlines)
                var state = false
                for element in myStrings {
                    if element == "BEGIN:VEVENT" {
                        state = true
                    } else if element == "END:VEVENT" {
                        state = false
                        serviceAppointment.summary = ""
                    }
                    if state {
                        if getElementByKey(element: element).1 != nil {
                            
                            getVariableByKey(key: getElementByKey(element: element).0!, keyValue: getElementByKey(element: element).1!, thisAppointment: serviceAppointment)
                            
                            if serviceAppointment.isReadyToAdd() {
                                appointments.append(Appointment(summary: serviceAppointment.summary, location: serviceAppointment.location))
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
        case "SUMMARY:":
            thisAppointment.summary = keyValue
        case "CREATED:":
            thisAppointment.location = keyValue
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
