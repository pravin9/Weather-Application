import SwiftUI

struct HourlyForecast: View {
    
    @State private var unit: UnitOfMesaure = .metric
    @StateObject private var manager = OneCallApiManager()
    @ObservedObject var locationManager = GetLocation()
    
    var body: some View {
        ZStack {
            Image("")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .frame(width: 200, height: .infinity)
                .blur(radius: 3)
                .opacity(1)
            VStack {
                Text("Hourly Forecast")
                    .foregroundColor(.blue)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                Spacer()
                if let data = manager.weather {
                    if let current = data.current {
                        VStack {
                            Text("\(current.dt)")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .semibold))
                            HStack {
                                Image(systemName: current.icon)
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 162, height: 80)
                                VStack {
                                    Text(current.weather.description.capitalized)
                                        .foregroundColor(.black)
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Text(current.temp)
                                        .font(.system(size: 40, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding()
                        .background(
                            Color
                                .black
                                .opacity(0.5)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                        )
                    }
                    ScrollView {
                        VStack {
                        ForEach (data.hourlyForecasts) { item in
                            HStack(spacing: 20) {
                                Image(systemName: item.icon)
                                    .resizable()
                                    .renderingMode(.original)
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                VStack (alignment: .leading) {
                                    Text(item.weather.description.capitalized)
                                        .foregroundColor(.white)
                                    Text(item.dt)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                Text("\(item.temp)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .medium))
                            }
                        }
                        .padding()
                        }
                        .padding()
                        .background(
                            Color
                                .black
                                .opacity(0.6)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        )
                        .padding(.horizontal, 20)
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
                Spacer()
            }
            
            .onAppear {
                Task {
                    await manager.getFiveDayForecast(unit: self.unit, currentLat: locationManager.location?.latitude ?? 51.5080928135367, currentLon: locationManager.location?.longitude ?? -0.1280628240539382)
                }
            }
        }
    }
}

struct HourlyForecast_Previews: PreviewProvider {
    static var previews: some View {
        HourlyForecast()
    }
}
