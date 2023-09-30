//
//  TKCalendarDesign.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/28/23.
//

import Foundation

struct TKCalendarDesign {
    let dayCellSize: CGSize
    let rowsCount: Int

    func getMonthCellHeight() -> CGFloat {
        CGFloat(rowsCount) * dayCellSize.height
    }
}
