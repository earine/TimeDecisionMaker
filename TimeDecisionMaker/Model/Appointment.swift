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
    public var UID : String
    public var descriptionAp : String?
    public var status : Status!
    public var dateInterval : DateInterval!
    public var dateStart : Date!
    public var dateEnd : Date!
    private let dateFormatter = DateFormatter()
    
    override init() {
        self.summary = ""
        self.UID = ""
        self.created = Date()
        self.status = Status.UNSET
    }
    
    public init(summary: String, created: Date, UID: String, status: Status, description: String, dateStart: Date, dateEnd: Date) {
        self.summary = summary
        self.UID = UID
        self.status = status
        self.descriptionAp = description
        self.created = created
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.dateInterval = DateInterval(start: dateStart, end: dateEnd)
    }
    
    public func isReadyToAdd() -> Bool {
        return !(summary.isEmpty || summary == "" || UID.isEmpty || UID == "" && status == Status.UNSET)
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
    
    public func typeFromString(value: String) -> Status {
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
    
    public func makeModelEmptyForChecking() {
        self.summary = ""
        self.UID = ""
        self.status = Status.UNSET
    }
    
    public func convertStringToDate(value: String, timezone: String) -> Date {
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        if let date = dateFormatter.date(from: value) {
            return date.convertToTimeZone(initTimeZone:TimeZone(abbreviation: "UTC")!, timeZone: TimeZone(identifier: timezone)!)
        } else {
            return Date()
        }
    }
    
    public func dateToString(date: Date) -> String {
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: date)
    }
}

enum Status : String {
    
    case TENTATIVE = "Tentative"
    case CONFIRMED = "Confirmed"
    case CANCELLED = "Cancelled"
    case UNSET
    
    var description: String {
        return self.rawValue
    }
}

