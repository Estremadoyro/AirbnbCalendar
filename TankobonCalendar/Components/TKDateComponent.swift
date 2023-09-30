//
//  TKDateComponent.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/25/23.
//
// https://sarunw.com/posts/getting-number-of-days-between-two-dates/

import Foundation

struct TKDateComponent {
    // MARK: - Public State
    let startDate: Date
    let endDate: Date

    // MARK: - Private State
    private static let calendar = Calendar(identifier: .gregorian)

    // MARK: - Initializers
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}

// MARK: - API
extension TKDateComponent {
    typealias TKDateComponents = (days: Int?, months: Int?, years: Int?)
    func getDateComponentsBetween(includesStart: Bool = true) -> TKDateComponents? {
        let days   = abs(startDate.days(from: endDate))
        let months = abs(startDate.months(from: endDate))
        let years  = abs(startDate.years(from: endDate))
        return includesStart ? (days+1, months+1, years+1) : (days, months, years)
    }
    
    static func getDatesByMonth(fromDate: Date, toDate: Date, monthsCount: Int) -> [Date] {
        /// Check if **startDate** is past **endDate**
        let reverse: Bool = fromDate.timeIntervalSince1970 > toDate.timeIntervalSince1970
        
        let fromDate: Date = Self.calendar.startOfDay(for: fromDate)
        let month: Int     = fromDate.month + 1 // Account for custom extension.
        let year: Int      = fromDate.year
        
        // 1. Get date for the 1st day of the month, as days are not relevant attm.
        guard let firstDayOfMonthDate = Self.calendar.date(from: DateComponents(year: year, month: month)) else { return [] }
        
        var datesByMonth: [Date] = []
        
        let range = reverse ? (0..<monthsCount).reversed() : Array(0..<monthsCount)
        for i in range {
            let nextMonthDate = Self.calendar.date(byAdding: .month, value: reverse ? -i : i, to: firstDayOfMonthDate)
            datesByMonth.append(nextMonthDate ?? Date())
        }
        
        return reverse ? datesByMonth.reversed() : datesByMonth
    }

    typealias TKMonthMetaData = (numberOfDays: Int, firstDayOfWeekIndex: Int, firstDayOfWeekName: String)
    static func getMonthMetaData(from fromDate: Date) -> TKMonthMetaData? {
        let fromDate = Self.calendar.startOfDay(for: fromDate)

        // 1. Get number of days in month
        guard let daysInMonthCount = Self.calendar.range(of: .day, in: .month, for: fromDate)?.count else { return nil }

        // 2. Get the first week-day(Index) in month
        let yearAndMonthComponents = Self.calendar.dateComponents([.year, .month], from: fromDate)
        /// The **fromDate** starting from the 1st day of it. i.e: 2023-09-27 -> 2023-09-01
        guard let firstDayOfMonthDate = Self.calendar.date(from: yearAndMonthComponents) else { return nil }
        let firstDayOfWeekIndex = Self.calendar.component(.weekday, from: firstDayOfMonthDate) - 1
        
        // 3. Get the name of the week-day(Index)
        guard let firstDayOfWeekName = Self.calendar.weekdaySymbols[safe: firstDayOfWeekIndex] else { return nil }
        
        return (daysInMonthCount, firstDayOfWeekIndex, firstDayOfWeekName)
    }
    
    static func getNumberWeeksInMonth(firstDayOfWeekIndex: Int, daysInMonthCount: Int) -> Int {
        let totalDaysInMonth = firstDayOfWeekIndex + daysInMonthCount
        return totalDaysInMonth / 7
    }
}

// MARK: - Detail
private extension TKDateComponent {
    static func getDateFromStr(_ dateStr: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale.current

        return formatter.date(from: dateStr) ?? Date()
    }
}
