//
//  Helpers.swift
//  WeatherApp_CW2_PB
//
//  Created by Mahen Dunusinghe on 2022-05-21.
//

import Foundation
import CoreLocation

enum UnitOfMesaure: String, Equatable {
    case metric = "metric"
    case imperial = "imperial"
}

extension Date {
    func get(_ type: Calendar.Component)-> Int {
        let calendar = Calendar.current
        let t = calendar.component(type, from: self)
        return Int(t < 10 ? "0\(t)" : t.description) ?? 0
    }
}

extension Double {
    func fixedTo(_ places: Int) -> Double {
        let divisor: Double = pow(10, Double(places))
        return (divisor * self).rounded() / divisor
    }
}

extension Int {
    func unixToDate(date: Date.FormatStyle.DateStyle = .long, time: Date.FormatStyle.TimeStyle = .omitted) -> String? {
        return Date(timeIntervalSince1970: TimeInterval(self)).formatted(date: date, time: time)
    }
    
    func unixToDate(date: Date.FormatStyle.DateStyle = .long, time: Date.FormatStyle.TimeStyle = .omitted) -> Date? {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}


