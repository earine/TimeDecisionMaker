//
//  Appointment.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/7/19.
//

import Foundation

class Appointment : NSObject {
    
    public var summary : String
    public var created : Date!
    public var status : Status!
    public var descriptionAp : String!
    public var UID : String
    public var dateInterval : DateInterval!
    public var dateStart : Date!
    public var dateEnd : Date!
    public var stamp : Date!
    public var lastModified : Date!
    public var location : String
    public var sequence : Int!
    public var transparency : Transparency!
    
    private let dateFormatter = DateFormatter()
    
    override init() {
        self.summary = ""
        self.UID = ""
        self.created = Date()
        self.status = Status.UNSET
        self.descriptionAp = ""
        self.location = ""
        self.transparency = Transparency.UNSET
    }
    
    public init(summary: String, created: Date, UID: String, status: Status, description: String, dateStart: Date, dateEnd: Date, lastModified: Date, location: String, sequence: Int, transparency : Transparency, stamp: Date) {
        self.summary = summary
        self.UID = UID
        self.status = status
        self.descriptionAp = description
        self.created = created
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.dateInterval = DateInterval(start: dateStart, end: dateEnd)
        self.lastModified = lastModified
        self.location = location
        self.sequence = sequence
        self.transparency = transparency
        self.stamp = stamp
    }
    
    public func isReadyToAdd() -> Bool {
        return !(summary.isEmpty || summary == "" || UID.isEmpty || UID == "" || status == Status.UNSET || sequence == nil || transparency == Transparency.UNSET)
    }
    
    public func getWeekDay(date: Date) -> String {
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: date)
    }
    
    public func getDayFromDate(date: Date) -> String {
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }
    
    public func hoursValueFromDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
       
        return dateFormatter.string(from: date)
    }
    
    public func durarationToString(dateInterval: DateInterval) -> String {
        if dateInterval.duration.format(using: [.minute]) == "0m"{
            print("true")
            return dateInterval.duration.format(using: [.hour]) ?? ""
        } else {
        return dateInterval.duration.format(using: [.hour, .minute]) ?? ""
        }
    }
    
    public func statusTypeFromString(value: String) -> Status {
        switch value {
        case "TENTATIVE":
            return Status.TENTATIVE
        case "CONFIRMED":
            return Status.CONFIRMED
        case "CANCELLED":
            return Status.CANCELLED
        default:
            return Status.TENTATIVE
        }
    }
    
    public func transparencyTypeFromString(value: String) -> Transparency {
        switch value {
        case "OPAQUE":
            return Transparency.OPAQUE
        case "TRANSPARENT":
            return Transparency.TRANSPARENT
        default:
            return Transparency.TRANSPARENT
        }
    }
    
    
    public func makeModelEmptyForChecking() {
        self.summary = ""
        self.UID = ""
        self.status = Status.UNSET
        self.transparency = Transparency.UNSET
    }
    
    public func convertStringToDate(value: String, timezone: String, format: String) -> Date {
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: value) {
            return date.convertToTimeZone(initTimeZone:TimeZone(abbreviation: "UTC")!, timeZone: TimeZone(identifier: timezone)!)
        } else {
            return Date()
        }
    }
   
}

enum Status : String {
    
    case TENTATIVE = "TENTATIVE"
    case CONFIRMED = "CONFIRMED"
    case CANCELLED = "CANCELLED"
    case UNSET
    
    var description: String {
        return self.rawValue
    }
}

/// Events that consume actual time for the individual or resource associated with the calendar SHOULD be recorded as OPAQUE, allowing them to be detected by free-busy time searches. Other events, which do not take up the individual's (or resource's) time SHOULD be recorded as TRANSPARENT, making them invisible to free-busy time searches.
enum Transparency : String {
    case OPAQUE = "OPAQUE"
    case TRANSPARENT = "TRANSPARENT"
    case UNSET
    
    var description: String {
        return self.rawValue
    }
}
