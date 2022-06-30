import SwiftUI

struct FiveDayForecastCityView: View {
    
    @State private var unit: UnitOfMesaure = .metric
    @StateObject private var manager = OneCallApiManager()
    @State private var cityName = ""
    @ObservedObject var locationManager = GetLocation()
    
    var body: some View {
        ZStack {
            Image("")
                .resizable()
                .frame(width: 400)
                .ignoresSafeArea()
                .blur(radius: 3)
                .opacity(1)
                
            
            ScrollView {
                VStack {
                    Text("5 Day Forecast")
                        .foregroundColor(.blue)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    Picker("Unit of Measure", selection: $unit) {
                        Text("Metric").tag(UnitOfMesaure.metric)
                        Text("Imperial").tag(UnitOfMesaure.imperial)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .onChange(of: unit) { _ in
                        Task {
                            await manager.getFiveDayForecast(unit: self.unit, currentLat: locationManager.location?.latitude ?? 51.5080928135367, currentLon: locationManager.location?.longitude ?? -0.1280628240539382)
                        }
                    }
                    if let data = manager.weather?.forecast {
                        ForEach(0..<5) { index in
                            let forecastWeatherObj = data[index]
                            VStack {
                                Text("\(forecastWeatherObj.dt)")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Divider()
                                    .frame(height: 1.5)
                                    .background(Color.white)
                                
                                HStack(){
                                    Image(systemName: forecastWeatherObj.icon)
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                    
                                    Spacer()
                                    
                                    VStack {
                                        HStack {
                                            Image(systemName: "thermometer")
                                                .foregroundColor(.red)
                                            Text("\(forecastWeatherObj.temp)")
                                                .foregroundColor(Color.white)
                                            
                                            Image(systemName: "drop.fill")
                                                .foregroundColor(.blue)
                                            Text("\(forecastWeatherObj.humidity)%")
                                                .foregroundColor(Color.white)
                                        }
                                        HStack {
                                            Image(systemName: "wind")
                                                .foregroundColor(.gray)
                                            Text("\(forecastWeatherObj.wind_speed)%")
                                                .foregroundColor(Color.white)
                                            
                                            Image(systemName: "icloud")
                                                .foregroundColor(.white)
                                            Text("\(forecastWeatherObj.clouds)")
                                                .foregroundColor(Color.white)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text(forecastWeatherObj.weather.description.capitalized)
                                            .foregroundColor(Color.white)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.center)
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                    }
                                }
                            }
                            .padding()
                            .background(
                                Color
                                    .black
                                    .opacity(0.6)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            )
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                        }
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
                .onAppear {
                    Task {
                        await manager.getFiveDayForecast(unit: self.unit, currentLat: locationManager.location?.latitude ?? 51.5080928135367, currentLon: locationManager.location?.longitude ?? -0.1280628240539382)
                    }
                }
            }
        }
    }
}

struct FiveDayForecastCityView_Previews: PreviewProvider {
    static var previews: some View {
        FiveDayForecastCityView()
    }
}
