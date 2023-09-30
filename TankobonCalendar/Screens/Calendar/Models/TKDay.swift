//
//  TKDay.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/25/23.
//

import Foundation

final class TKDay: Hashable, Identifiable {
    static let calendar = Calendar(identifier: .gregorian)
    
    var day: Int
    var month: Int
    var year: Int
    var selectable: Bool = true
    var isSelected: Bool = false
    var date: Date
    var dateFormated: String
    
    var id: String { "\(String(day))+\(month)+\(year)" }
    
    init(day: Int, month: Int, year: Int, selectable: Bool, isSelected: Bool = false) {
        self.day = day
        self.month = month
        self.year = year
        self.selectable = selectable
        self.isSelected = isSelected
        
        self.date = Self.makeDateFrom(year: year, month: month, day: day)
        self.dateFormated = Self.makeDateFormatedFrom(date: date)
    }
    
    static func == (lhs: TKDay, rhs: TKDay) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Detail
private extension TKDay {
    static func makeDateFrom(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month+1, day: day)
        return Self.calendar.date(from: components) ?? Date()
    }
    
    static func makeDateFormatedFrom(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
