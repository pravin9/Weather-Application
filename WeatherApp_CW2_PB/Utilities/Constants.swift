//
//  Constants.swift
//  WeatherApp_CW2_PB
//
//  Created by Mahen Dunusinghe on 2022-05-21.
//

import Foundation

enum API {
    static let currentLocationWeatherApi: String = "https://api.openweathermap.org/data/2.5/weather?appid=16955122b246394ea4515a34069f70b2"
    static let weatherLocationApi: String = "https://api.openweathermap.org/data/2.5/onecall?exclude=hourly,minutely&appid=16955122b246394ea4515a34069f70b2"
    static let forecastWeatherLocationApi: String = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely&appid=16955122b246394ea4515a34069f70b2"
}

enum TabType: Int, CaseIterable {
    case home = 0
    case cityWeather
    case forecast
    case hourlyForecast
    
    var tabItem: TabItemData {
        switch self {
        case .home:
            return TabItemData(image: "cloud", selectedImage: "cloud.fill", title: "Current")
        case .forecast:
            return TabItemData(image: "goforward.5", selectedImage: "5.circle.fill", title: "5 Day")
        case .hourlyForecast:
            return TabItemData(image: "hourglass.circle", selectedImage: "hourglass.circle.fill", title: "Hourly")
        case .cityWeather:
            return TabItemData(image: "magnifyingglass.circle", selectedImage: "magnifyingglass.circle.fill", title: "Search")
        }
    }
}
