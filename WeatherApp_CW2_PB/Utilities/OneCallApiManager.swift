//
//  OneCallApiManager.swift
//  WeatherApp_CW2_PB
//
//  Created by Mahen Dunusinghe on 2022-05-22.
//

import Foundation

class OneCallApiManager: ObservableObject {
    
    @Published var weather: OneCallWeatherModel?
    private var unit: UnitOfMesaure = .metric
    
    func getFiveDayForecast(unit: UnitOfMesaure, currentLat: Double, currentLon: Double) async {
        
        self.unit = unit
        let url = "\(API.forecastWeatherLocationApi)&lat=\(currentLat)&lon=\(currentLon)&units=\(unit.rawValue)"
        await requestForecast(url: url)
    }
    
    func requestForecast(url: String) async {
        guard let url = URL(string: url) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let weather =  try JSONDecoder().decode(OneCallWeather.self, from: data)
            DispatchQueue.main.async {
                let forecasts = weather.daily.map { daily in
                    OCWeatherDisplay(
                        dt: daily.dt.unixToDate()!,
                        temp: self.unit == .metric ? "\(daily.temp.day)°C" : "\(daily.temp.day)°F",
                        pressure: daily.pressure,
                        humidity: daily.humidity,
                        clouds: daily.clouds,
                        wind_speed: self.unit == .metric ? "\(daily.wind_speed) m/s" : "\(daily.wind_speed) mi/h",
                        weather: daily.weather.first!,
                        icon: self.getIcon(id: daily.weather.first!.id))
                }
                
                let first = weather.hourly.first!
                let current = OCWeatherDisplayHourly(
                    dt: first.dt.unixToDate(date: .complete, time: .shortened)!,
                    temp: self.unit == .metric ? "\(first.temp)°C" : "\(first.temp)°F",
                    weather: first.weather.first!,
                    icon: self.getIcon(id: first.weather.first!.id),
                    hour: first.dt.unixToDate()!.get(.hour))
                var hourly = weather.hourly.map { hourly in
                    OCWeatherDisplayHourly(
                        dt: hourly.dt.unixToDate(date: .omitted, time: .shortened)!,
                        temp: self.unit == .metric ? "\(hourly.temp)°C" : "\(hourly.temp)°F",
                        weather: hourly.weather.first!,
                        icon: self.getIcon(id: hourly.weather.first!.id),
                        hour: hourly.dt.unixToDate()!.get(.hour))
                }
                
                hourly = hourly.filter({ item in
                    return item.hour % 3 == 0
                })
                
                self.weather = OneCallWeatherModel(forecast: forecasts,
                                              hourlyForecasts: hourly,
                                              current: current)
            }
            print("OCWeather: ",weather)
        } catch {
            print("OCError: ",error.localizedDescription)
        }
    }
    
    func getIcon(id: Int) -> String {
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
}
