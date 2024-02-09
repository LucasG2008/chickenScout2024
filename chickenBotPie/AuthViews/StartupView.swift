//
//  StartupView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/23/24.
//

import SwiftUI

struct StartupView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var UserManager: UserManagement
    
    var body: some View {
        NavigationView {
            VStack {
                // Image at the top
                // image
                if colorScheme == .light {
                    Image("chicken-light")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                } else {
                    Image("chicken-dark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                }
                // Welcome text
                Text("Welcome to ChickenScout!")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 36, design: .rounded))
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                    .padding([.leading, .trailing], 10)
                
                Spacer()
                
                VStack(spacing: 12) {
                    // Navigation links
                    NavigationLink(destination: LoginView()) {
                        StartupButton(label: "Log In", color: "dark")
                            
                    }
                    .navigationBarHidden(true)
                    
                    NavigationLink(destination: RegistrationView(UserManager: UserManager)) {
                        StartupButton(label: "Sign Up", color: "light")
                    }
                    .padding(.top, 16)
                    .navigationBarHidden(true)

                }
                
                Spacer()
                
                // Sign in as guest
                NavigationLink {
                    GuestLoginView(UserManager: UserManager)
                    
                } label: {
                    HStack(spacing: 3) {
                        Text("No connection? ")
                        Text("Sign in as a Guest")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.blue)  // Set text color to blue
                }
                .padding(.top, 16)
                
            }
            
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Group {
                    if colorScheme == .light {
                        LinearGradient(gradient: Gradient(colors: [Color.lightBlueStart, Color.lightBlueEnd]), startPoint: .top, endPoint: .bottom)
                    } else {
                        LinearGradient(gradient: Gradient(colors: [Color.darkBlueStart, Color.darkBlueEnd]), startPoint: .top, endPoint: .bottom)
                    }
                }
                .edgesIgnoringSafeArea(.all))
        }
    }
}

struct StartupButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var label: String
    var color: String
    
    var body: some View {
        
        if color == "dark" {
            
            HStack {
                Text(label)
                    .fontWeight(.semibold)
                Image(systemName: "arrow.right")
            }
            .foregroundStyle(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            
            .background(
                LinearGradient(gradient: colorScheme == .dark ? Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]) : Gradient(colors: [Color(hex: "#0047AB").opacity(1), Color(hex: "#0047AB").opacity(0.8)]), startPoint: .top, endPoint: .bottom)
            )
            .cornerRadius(10)
            
        } else {
            
            HStack {
                Text(label)
                    .fontWeight(.semibold)
                Image(systemName: "arrow.right")
            }
            .foregroundStyle(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            
            
            .background(
                LinearGradient(gradient: colorScheme == .dark ? Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)]) : Gradient(colors: [Color(hex: "#0047AB").opacity(0.6), Color(hex: "#0047AB").opacity(0.4)]), startPoint: .top, endPoint: .bottom)
            )
            .cornerRadius(10)
        }
    }
}

struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        StartupView(UserManager: UserManagement())
    }
}
