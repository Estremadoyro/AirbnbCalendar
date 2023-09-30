//
//  TankobonReusable.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/24/23.
//

protocol TankobonReusable {
    static var reuseId: String { get }
}

extension TankobonReusable {
    static var reuseId: String { String(describing: Self.self) }
}
