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
        let organizerFreeSlots = makeDateIntervalList(objects: service.fetchAppointment(resourceFile: organizerICS))
        let attendeeFreeSlots = makeDateIntervalList(objects: service.fetchAppointment(resourceFile: attendeeICS))
        
        let suggestedAppointments = findTimeForAppointment(person1: organizerFreeSlots, person2: attendeeFreeSlots, duration: duration)
        if suggestedAppointments.isEmpty {
            return []
        } else {
            return suggestedAppointments
        }
    }
    
    private func makeDateIntervalList(objects: [Appointment]) -> [DateInterval]{
        var dateIntervals = [DateInterval]()
        
        for object in objects {
            dateIntervals.append(object.dateInterval)
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
            return []
        }
        for i in 0..<dates.count {
            if i < dates.count-1 && dates[i].start != dates[i+1].start && dates[i].end != dates[i+1].end {
                freeSlots.append(DateInterval.init(start: dates[i].end, end: dates[i+1].start))
            }
        }
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

