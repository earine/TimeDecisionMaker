//
//  DateExtension.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/14/19.
//

import Foundation

extension Date {
    
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
        return addingTimeInterval(delta)
    }
    
    func dayAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("d")
        return df.string(from: self)
    }
    
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM")
        return df.string(from: self)
    }
    
    func yearAsString() -> Int {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("yyyy")
        return Int(df.string(from: self))!
    }
    
    func dateToString() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd MMM HH:mm"
        return df.string(from: self)
    }
    
    func getWeekDay() -> String {
         let df = DateFormatter()
        df.dateFormat = "EE"
        return df.string(from: self)
    }
}

