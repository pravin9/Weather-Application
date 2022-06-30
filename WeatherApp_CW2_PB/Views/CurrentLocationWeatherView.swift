import SwiftUI
import CoreLocationUI
import MapKit

struct CurrentLocationWeatherView: View {
    
    @State private var isNight: Bool = false
    @StateObject var manager = WeatherManager()
    @StateObject var oneCallApiManager = OneCallApiManager()
    @ObservedObject var locationManager = GetLocation()
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: $isNight)
            
            VStack {
                if (manager.weather != nil) {
                    Spacer()
                    WeatherCityName(cityName: manager.weather?.name ?? "_")
                    
                    MainWeatherView(imageName: isNight ? "moon.stars.fill" : manager.weather?.conditionIcon ?? "cloud.fill", temprature: manager.weather?.tempString ?? "0")
                    
                    HStack(spacing: 20) {
                        if let data = oneCallApiManager.weather?.forecast {
                            ForEach(0..<5) { index in
                                let forecastWeatherObj = data[index]
                                WeatherDayView(dayOfWeekk: forecastWeatherObj.dt, imageName: forecastWeatherObj.icon, temprature: forecastWeatherObj.temp)
                            }
                        }
                    }
                    .padding()
                    .background(
                        
                        Color.black.opacity(0.6)
                            .frame(width: 350)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    )
                    
                    Spacer()
                } else {
                    ProgressView {
                        Text("Fetching Data...")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                    .scaleEffect(1.5, anchor: .center)
                    .padding(35)
                    .background(
                        Color
                            .black
                            .opacity(0.8)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    )
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            Task {
                locationManager.requestAllowOnceLocationPermission()
                await manager.getCurrentLocationWeather(currentLat: locationManager.location?.latitude ?? 51.5080928135367, currentLon: locationManager.location?.longitude ?? -0.1280628240539382)
                await oneCallApiManager.getFiveDayForecast(unit: .metric, currentLat: locationManager.location?.latitude ?? 51.5080928135367, currentLon: locationManager.location?.longitude ?? -0.1280628240539382)
            }
        }
    }
}

struct CurrentLocationWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationWeatherView()
    }
}

struct WeatherDayView: View {
    
    var dayOfWeekk: String
    var imageName:String
    var temprature: String
    
    var body: some View {
        VStack {
            Text(dayOfWeekk)
                .foregroundColor(.white)
                .font(.system(size: 15, weight: .medium))
                .multilineTextAlignment(.center)
            Image(systemName: imageName).renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(temprature)")
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .medium))
        }
    }
}

struct BackgroundView: View {
    
    @Binding var isNight: Bool
    
    var body: some View {
        Image("")
            .resizable()
            .ignoresSafeArea()
            .blur(radius: 3)
            .scaledToFill()
            .opacity(1)
    }
}

struct MainWeatherView: View {
    var imageName: String
    var temprature: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text("\(temprature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.black)
        }
        .padding(.bottom, 40)
    }
}

struct WeatherCityName: View {
    var cityName: String
    
    var body: some View {
        Text(cityName).font(.system(size: 38, weight: .semibold, design: .default)).foregroundColor(.black)
            .padding()
    }
}

struct CustomWeatherButton: View {
    var buttonName: String
    var body: some View {
        Text(buttonName)
            .frame(width: 280, height: 50)
            .background(Color.white)
            .font(.system(size: 20, weight: .bold, design: .default))
            .cornerRadius(10)
    }
}


