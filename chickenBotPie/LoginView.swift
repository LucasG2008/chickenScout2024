//
//  LoginView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/20/24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack{
            
            LinearGradient(
                gradient: Gradient(colors: [Color.lightBlue, Color.darkBlue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    Spacer()
                    Text("Welcome to ChickenScout!")
                        .font(.system(size: 45, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    TextField("Email", text: $email)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .padding()
                    
                    Button(action: {
                        //register()
                    }) {
                        Text("Sign Up")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Button(action: {
                        //login()
                    }) {
                        Text("Already have an account? Login")
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    Spacer()
                }
                    .padding()
            )
        }
    }
}

#Preview {
    LoginView()
}
