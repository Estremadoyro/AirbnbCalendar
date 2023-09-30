//
//  Array-Unwrap.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/26/23.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        get {
            if index >= 0, index < self.count { return self[index] }
            else { return nil }
        }
    }
}
