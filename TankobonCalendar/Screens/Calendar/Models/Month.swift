//
//  Month.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/24/23.
//

import Foundation

enum Month: String, Hashable, Identifiable, CaseIterable {
    var id: String { self.rawValue }
    
    case january   = "january"
    case february  = "february"
    case march     = "march"
    case april     = "april"
    case may       = "may"
    case june      = "june"
    case july      = "july"
    case august    = "august"
    case september = "september"
    case october   = "october"
    case november  = "november"
    case december  = "december"
    
    init(monthIndex: Int) {
        switch monthIndex {
        case 0: self  = .january
        case 1: self  = .february
        case 2: self  = .march
        case 3: self  = .april
        case 4: self  = .may
        case 5: self  = .june
        case 6: self  = .july
        case 7: self  = .august
        case 8: self  = .september
        case 9: self  = .october
        case 10: self = .november
        case 11: self = .december
        default: self = .january
        }
    }
    
    static func ==(rhs: Self, lhs: Self) -> Bool {
        rhs.rawValue == lhs.rawValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
}
