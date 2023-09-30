//
//  TKMonth.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/26/23.
//

import Foundation

struct TKMonth: Hashable, Identifiable {
    let date: Date
    let month: Int
    let year: Int

    var name: String { Calendar.current.monthSymbols[safe: month] ?? "" }

    var id: String { "\(month)-\(year)" }

    var days: [TKDay] = []

    init(date: Date, month: Int, year: Int) {
        self.date = date
        self.month = month
        self.year = year
        self.days = makeTKDays()
    }
    
    static func ==(lhs: TKMonth, rhs: TKMonth) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - API
extension TKMonth {
    static func getMonths(fromDate: Date, toDate: Date) -> [TKMonth] {
        let tkDateComponent = TKDateComponent(startDate: fromDate, endDate: toDate)
        print("Start date: \(tkDateComponent.startDate)")
        print("End date: \(tkDateComponent.endDate)")
        
        guard let componentsBetween = tkDateComponent.getDateComponentsBetween() else { return [] }
        let (monthsBetweenCount) = componentsBetween.months
        guard let monthsBetweenCount else { return [] }
        
        let datesByMonth = TKDateComponent.getDatesByMonth(fromDate: fromDate, toDate: toDate, monthsCount: monthsBetweenCount)
        
        let tkMonths = datesByMonth.map { TKMonth(date: $0, month: $0.month, year: $0.year) }
        print("tkMonths: \(tkMonths.map(\.id))")
        
        return tkMonths
    }
}

// MARK: - Detail
private extension TKMonth {
    /// Make **all** the visible days inside a **month** including both the current's and past's days.
    func makeTKDays() -> [TKDay] {
        guard let (daysInMonthCount,
                   firstDayOfWeekIndex,
                   _) = TKDateComponent.getMonthMetaData(from: date) else { return [] }
        let totalDaysCount: Int = daysInMonthCount + firstDayOfWeekIndex

        let tkDays = (1 ... totalDaysCount).map {
            let selectable = $0 > firstDayOfWeekIndex
            let day = $0 > firstDayOfWeekIndex ? max($0 - firstDayOfWeekIndex, 0) : $0
            return TKDay(day: day, month: month, year: year, selectable: selectable)
        }

//        print("TK DAYS: \(tkDays)")
        return tkDays
    }
}
