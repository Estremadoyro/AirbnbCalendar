//
//  TKColor.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/25/23.
//

import class UIKit.UIColor

enum TKColor {
    static let prefix: String = "tk-"
    
    static var white: UIColor { UIColor(named: Self.prefix+"white") ?? UIColor() }
    static var black: UIColor { UIColor(named: Self.prefix+"black") ?? UIColor() }
}
