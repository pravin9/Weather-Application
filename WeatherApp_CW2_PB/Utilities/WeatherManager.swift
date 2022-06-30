//
//  WeatherManager.swift
//  WeatherApp_CW2_PB
//
//  Created by Mahen Dunusinghe on 2022-05-21.
//

import Foundation
import CoreLocation

enum WeatherUnit: String, Equatable {
    case metric = "metric"
    case imperial = "imperial"
}

class WeatherManager: ObservableObject {
    
    @Published var weather: WeatherModel?
    private var unit: UnitOfMesaure = .metric
    
    func getCurrentLocationWeather(currentLat: Double, currentLon: Double) async -> Bool {
        let url = "\(API.currentLocationWeatherApi)&lat=\(currentLat)&lon=\(currentLon)&units=metric"
        
        return await requestWeather(url: url)
    }
    
    func getLocationWeatherForCity(string: String, unit: UnitOfMesaure) async -> Bool {
        self.unit = unit
        let url = "\(API.currentLocationWeatherApi)&q=\(string)&units=\(unit.rawValue)"

        return await requestWeather(url: url)
    }
    
    func requestWeather(url: String) async -> Bool {
        guard let url = URL(string: url) else { return true }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let weather =  try JSONDecoder().decode(LocationWeatherObject.self, from: data)
            DispatchQueue.main.async {
                self.weather = WeatherModel(id: weather.weather.first?.id ?? 0,
                                            name: weather.name,
                                            temperature: weather.main.temp,
                                            description: weather.weather.first?.description ?? "",
                                            humidity: weather.main.humidity,
                                            pressure: weather.main.pressure,
                                            windSpeed: weather.wind.speed,
                                            direction: weather.wind.deg,
                                            cloudPercentage: weather.clouds.all,
                                            unit: self.unit)
            }
            return false
        } catch {
            print(error.localizedDescription)
            return true
        }
    }
}


final class GetLocation: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location:CLLocationCoordinate2D?
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAllowOnceLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }
        
        DispatchQueue.main.async {
            self.location = currentLocation.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
