import SwiftUI

extension UserDefaults{
    var isFirstLaunch: Bool {
        get {
            return(UserDefaults.standard.value(forKey: "isFirstLaunch") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isFirstLaunch")
        }
    }
}

struct GettingStarted: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                    .frame(width: 400, height: .infinity)
                    .opacity(0.9)
                    .blur(radius: 3)
                VStack(spacing: 40) {
                    VStack{
                        Text("Discover the Weather in your City")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .padding(.bottom, 10)
                        
                        Text("Get to know your weather forecast and metric values of your chooisng")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.system(size: 15))
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 350)
                    
                    NavigationLink {
                        ContentView()
                    } label: {
                        Text("Get Started")
                            .frame(width: 280, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(15)
                    }
                }
                
                .onAppear(perform: {
                    UserDefaults.standard.isFirstLaunch = true
                })
            }
        }
    }
}

struct GettingStarted_Previews: PreviewProvider {
    static var previews: some View {
        GettingStarted()
    }
}
