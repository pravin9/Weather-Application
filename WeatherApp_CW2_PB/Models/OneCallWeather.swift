import Foundation
import SwiftUI

struct OneCallWeatherModel {
    let forecast: [OCWeatherDisplay]
    let hourlyForecasts: [OCWeatherDisplayHourly]
    let current: OCWeatherDisplayHourly
}

struct OCWeatherDisplay: Identifiable {
    let id = UUID()
    let dt: String
    let temp: String
    let pressure: Int
    let humidity: Int
    let clouds: Int
    let wind_speed: String
    let weather: Weather
    let icon: String
}

struct OCWeatherDisplayHourly: Identifiable {
    let id = UUID()
    let dt: String
    let temp: String
    let weather: Weather
    let icon: String
    let hour: Int
}

struct OneCallWeather: Decodable {
    let current: Current
    let daily: [OCDaily]
    let hourly: [OCHourly]
}

struct Current: Decodable {
    let dt: Int
    let temp: Double
    let pressure: Int
    let humidity: Int
    let clouds: Int
    let wind_speed: Double
    let weather: [Weather]
}

struct OCDaily: Decodable {
    let dt: Int
    let temp: Temperature
    let pressure: Int
    let humidity: Int
    let clouds: Int
    let wind_speed: Double
    let weather: [Weather]
}

struct Temperature: Decodable {
    let day: Double
}

struct OCHourly: Decodable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}
