import SwiftUI

struct CityBasedWeather: View {
    
    @State private var cityName = ""
    @State private var isNight = false
    @State private var unitToggle = false
    @State private var showError = false
    @StateObject var manager = WeatherManager()
    
    var body: some View {
        ZStack {
            Image("")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 3)
                .opacity(1)
            ScrollView {
                VStack {
                    Text("City Based Search")
                        .foregroundColor(.blue)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    HStack {
                        TextField("Search for a City", text: $cityName)
                            .textFieldStyle(OvalTextFieldStyle())
                        
                        Button {
                            Task {
                                let response = await manager.getLocationWeatherForCity(string: self.cityName, unit: unitToggle ? .imperial : .metric)
                                showError = response
                            }
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 25))
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Toggle(isOn: $unitToggle) {
                        Text("Switch to \(unitToggle ? "Metric" : "Imperial") Units")
                    }
                    .padding(.horizontal, 20)
                    .onChange(of: unitToggle, perform: { _ in
                        Task {
                            await manager.getLocationWeatherForCity(string: self.cityName, unit: unitToggle ? .imperial : .metric)
                        }
                    })
                    
                    Spacer()
                    if(!showError) {
                        if (manager.weather?.detailedData) != nil {
                            VStack {
                                Text(manager.weather?.name ?? "")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                                    .fontWeight(.bold)
                                HStack {
                                    Image(systemName: manager.weather?.conditionIcon ?? "cloud.rain.fill")
                                        .resizable()
                                        .renderingMode(.original)
                                        .scaledToFit()
                                        .frame(width: 125, height: 125)
                                    VStack {
                                        Text("\(manager.weather?.tempString ?? "0")°")
                                            .foregroundColor(.white)
                                            .font(.system(size: 60))
                                            .fontWeight(.bold)
                                        Text(manager.weather?.description.capitalized ?? "")
                                            .foregroundColor(.white)
                                            .font(.system(size: 25))
                                            .fontWeight(.light)
                                    }
                                }
                            }
                            
                            .padding()
                            .background(
                                Color.black.opacity(0.6)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                
                            )
                            
                            VStack(spacing: 50) {
                                if let data = manager.weather?.detailedData {
                                    ForEach(data) { weatherData in
                                        HStack{
                                            Text(weatherData.title)
                                                .foregroundColor(.white)
                                                .font(.system(size: 16))
                                                .fontWeight(.bold)
                                            Spacer()
                                            HStack(){
                                                Image(systemName: weatherData.icon)
                                                    .resizable()
                                                    .foregroundColor(weatherData.color)
                                                    .scaledToFit()
                                                    .frame(width: 30, height: 30)
                                                Text("\(weatherData.value) \(weatherData.unit)")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 23))
                                                    .fontWeight(.bold)
                                            }
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
                            .padding()
                            .background(
                                Color.black.opacity(0.6)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                
                            )
                            .padding(.horizontal, 38)
                            .padding(.bottom, 30)
                        } else {
                            Text("Search for a local city to get weather updates")
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 18, weight: .semibold))
                                .padding()
                                .background(
                                    Color
                                        .black
                                        .opacity(0.6)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                )
                        }
                    } else {
                        Text("The city searched above is not available in the API or does not exist. Please recheck and try again.")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 18, weight: .semibold))
                            .padding()
                            .background(
                                Color
                                    .black
                                    .opacity(0.6)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            )
                    }
                    
                    Spacer()
                }
            }
            
        }
        
    }
}

struct CityBasedWeather_Previews: PreviewProvider {
    static var previews: some View {
        CityBasedWeather()
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.white.opacity(0.2))
            .cornerRadius(20)
            .shadow(color: .gray, radius: 10)
    }
}
