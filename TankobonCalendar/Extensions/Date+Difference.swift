//
//  Date+Difference.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/26/23.
//

import Foundation

extension Date {
    private static var calendar: Calendar { Calendar.current }
    
    static var currentMonth: Int { Calendar.current.component(.month, from: Date()) - 1  }
    static var currentYear: Int { Calendar.current.component(.year, from: Date()) }
    
    var month: Int { Calendar.current.component(.month, from: self) - 1 }
    var day: Int { Calendar.current.component(.day, from: self) - 1 }
    var year: Int { Calendar.current.component(.year, from: self) }
    
    func days(from toDate: Date) -> Int {
        let fromDate = Self.calendar.startOfDay(for: self)
        let toDate   = Self.calendar.startOfDay(for: toDate)
        
        let comps = Self.calendar.dateComponents([.day], from: fromDate, to: toDate)
        return comps.day ?? 0
    }
    
    func months(from toDate: Date) -> Int {
        let fromDate = Self.calendar.startOfDay(for: self)
        let toDate   = Self.calendar.startOfDay(for: toDate)
        
        let comps = Self.calendar.dateComponents([.month], from: fromDate, to: toDate)
        return comps.month ?? 0
    }
    
    func years(from toDate: Date) -> Int {
        let fromDate = Self.calendar.startOfDay(for: self)
        let toDate   = Self.calendar.startOfDay(for: toDate)
        
        let comps = Self.calendar.dateComponents([.year], from: fromDate, to: toDate)
        return comps.year ?? 0
    }
}
