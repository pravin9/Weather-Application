import Foundation
import SwiftUI

struct LocationWeatherObject: Decodable {
    let name: String
    let weather: [Weather]
    let main: Main
    let clouds: Clouds
    let wind: Wind
}

struct Main: Decodable {
    let temp: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Decodable {
    let id: Int
    let description: String
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
}

struct Clouds: Decodable {
    let all: Int
}

struct WeatherModel {
    let id: Int
    let name: String
    let temperature: Double
    let description: String
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
    let direction: Int
    let cloudPercentage: Int
    let unit: UnitOfMesaure
    
    var tempString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionIcon: String {
        switch id {
        case 200...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.rain.fill"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog.fill"
        case 800:
            return "cloud.sun.fill"
        case 801...804:
            return "sun.max.fill"
        default:
            return "cloud.fill"
        }
    }
    
    var detailedData: [WeatherDetailData] {
        return [
            .init(title: "Temperature", icon: "thermometer", color: Color.red, value: tempString, unit: self.unit == .metric ? "°C" : "°F"),
            .init(title: "Humidity", icon: "drop.fill", color: Color.blue, value: "\(humidity)", unit: "%"),
            .init(title: "Pressure", icon: "digitalcrown.horizontal.press.fill", color: Color.green, value: "\(pressure)", unit: "hPa"),
            .init(title: "Wind speed", icon: "wind", color: Color.blue, value: "\(windSpeed)", unit: self.unit == .metric ? "m/s" : "mi/h"),
            .init(title: "Wind direction", icon: "arrow.up.left.circle", color: Color.yellow, value: "\(direction)"),
            .init(title: "Cloud Percentage", icon: "icloud", color: Color.cyan, value: "\(cloudPercentage)"),
        ]
    }
    
}

struct WeatherDetailData: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let value: String
    var unit: String = ""
}
