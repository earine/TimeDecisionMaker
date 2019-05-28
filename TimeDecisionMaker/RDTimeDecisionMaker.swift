//
//  RDTimeDecisionMaker.swift
//  TimeDecisionMaker
//
//  Created by Mikhail on 4/24/19.
//

import Foundation


class RDTimeDecisionMaker: NSObject {
    /// Main method to perform date interval calculation
    ///
    /// - Parameters:
    ///   - organizerICSPath: path to personA file with events
    ///   - attendeeICSPath: path to personB file with events
    ///   - duration: desired duration of appointment
    /// - Returns: array of available time slots, empty array if none found
    
    var service = Service()
    
    func suggestAppointments(organizerICS:String,
                             attendeeICS:String,
                             duration:TimeInterval) -> [DateInterval] {
        var obj = service.fetchAppointment(resourceFile: organizerICS)
        let organizerFreeSlots = makeDateIntervalList(objects: obj)
        let attendeeFreeSlots = makeDateIntervalList(objects: service.fetchAppointment(resourceFile: attendeeICS))

        let suggestedAppointments = findTimeForAppointment(person1: organizerFreeSlots, person2: attendeeFreeSlots, duration: duration)
        if suggestedAppointments.isEmpty {
            return []
        } else {
            return suggestedAppointments
        }
    }
    
    public func makeDateIntervalList(objects: [Appointment]) -> [DateInterval]{
        var dateIntervals = [DateInterval]()
        
        for object in objects {
            if(object.dateInterval.end > Date()) {
            dateIntervals.append(object.dateInterval)
        }
        }
        
        dateIntervals.sort()
        
        var newList = [DateInterval]()
        newList.append(contentsOf: dateIntervals)
        for (i) in 0..<dateIntervals.count {
            for j in 0..<dateIntervals.count {
                if j != i && dateIntervals[i].contains(dateIntervals[j].start) && dateIntervals[i].contains(dateIntervals[j].end) {
                    if newList.contains(dateIntervals[j]) {
                        newList.remove(at: newList.firstIndex(of: dateIntervals[j])!)
                    }
                }
            }
        }
        return findFreeSlots(dates: newList)
    }
    
    private func findFreeSlots(dates: [DateInterval]) -> [DateInterval] {
        var freeSlots = [DateInterval]()
        guard dates.count > 1 else {
            if dates.first?.end != nil && dates.first?.start != nil{
                if dates.first!.end < Date() {
                    return [DateInterval.init(start: Date(), duration: 604800)]
                } else if dates.first!.start > Date() {
                    return [DateInterval(start: Date(), end: dates.first!.start), DateInterval(start: dates.first!.end, duration: 604800)]
                }
            } else {
                return [DateInterval.init(start: Date(), duration: 604800)]
            }
            return []
        }
        
        for i in 0..<dates.count {
            if i < dates.count-1 && dates[i].start != dates[i+1].start && dates[i].end != dates[i+1].end {
                freeSlots.append(DateInterval.init(start: dates[i].end, end: dates[i+1].start))
            }
        }
        
        freeSlots.append(DateInterval(start: Date(), end: dates.min()!.start))
        freeSlots.append(DateInterval(start: dates.max()!.end, duration: 604800))
        freeSlots.sort()
        return freeSlots
    }
    
    private func findTimeForAppointment(person1: [DateInterval], person2: [DateInterval], duration: TimeInterval) -> [DateInterval] {
        var optimalTimeIntervals = [DateInterval]()
        for p1 in person1 {
            for p2 in person2 {
                if p1.intersects(p2) {
                    if p1.intersection(with: p2)!.duration > duration {
                        optimalTimeIntervals.append(p1.intersection(with: p2)!)
                    }
                }
            }
        }
        return optimalTimeIntervals
    }
}

