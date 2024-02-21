//
//  MainView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/15/24.
//

import SwiftUI
import Firebase

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {

        manager.requestAlwaysAuthorization()
        
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
//        switch status {
//        case .notDetermined:
//            print("DEBUG: Not determined")
//        case .restricted:
//            print("DEBUG: Restricted")
//        case .denied:
//            print("DEBUG: Denied")
//        case .authorizedAlways:
//            print("DEBUG: Always")
//        case .authorizedWhenInUse:
//            print("DEBUG: When in use")
//        @unknown default:
//            break
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
}


@available(iOS 17.0, *)
struct MainView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @ObservedObject var UserManager: UserManagement
    
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        
        VStack {
            if UserManager.loggedIn == true {
                MainTabView(UserManager: UserManager)
                    .transition(.opacity.animation(.easeInOut(duration: 1)))
            } else {
                StartupView(UserManager: UserManager)
            }
        }
        .onAppear{
            LocationManager.shared.requestLocation()
        }

    }
    
}


extension Color {
    static let lightBlue = Color(red: 173/255, green: 216/255, blue: 230/255)
    static let darkBlue = Color(red: 25/255, green: 25/255, blue: 112/255)
    
    static let lightBlueStart = Color(#colorLiteral(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0))
    static let lightBlueEnd = Color(#colorLiteral(red: 0.6, green: 0.7, blue: 1.0, alpha: 1.0))
    
    static let darkBlueStart = Color(#colorLiteral(red: 0.1, green: 0.2, blue: 0.4, alpha: 1.0))
    static let darkBlueEnd = Color(#colorLiteral(red: 0.05, green: 0.1, blue: 0.25, alpha: 1.0))
    
    init(hex: String) {
            var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
            print(cleanHexCode)
            var rgb: UInt64 = 0
            
            Scanner(string: cleanHexCode).scanHexInt64(&rgb)
            
            let redValue = Double((rgb >> 16) & 0xFF) / 255.0
            let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
            let blueValue = Double(rgb & 0xFF) / 255.0
            self.init(red: redValue, green: greenValue, blue: blueValue)
        }
}
