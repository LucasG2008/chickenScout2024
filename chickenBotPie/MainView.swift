//
//  MainView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/15/24.
//

import SwiftUI
import Firebase

struct MainView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        VStack {
            if viewModel.userSession != nil {
                MainTabView()
                    .transition(.opacity.animation(.easeInOut(duration: 1)))
            } else {
                StartupView()
            }
        }
    }
    
}

#Preview {
    MainView()
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
