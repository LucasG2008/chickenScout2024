//
//  MainView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/15/24.
//

import SwiftUI
import Firebase

struct MainView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var userIsLoggedIn = false
    
    var body: some View {
        if userIsLoggedIn {
            
            TabView {
                TeamView().tabItem {
                    Text("Teams")
                    Image(systemName: "person.3")
                }.tag(1)
                
                ScoutingView().tabItem {
                    Text("Scouting")
                    Image(systemName: "list.bullet")
                }
                
                InputView().tabItem {
                    Text("Input")
                    Image(systemName: "square.and.pencil")
                }.tag(2)
            }
            
        } else {
            loginContent
        }
        
    }
    
    var loginContent: some View {
        
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
                        register()
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
                        login()
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
        .onAppear {
        Auth.auth().addStateDidChangeListener { auth, user in
        if user != nil {
        userIsLoggedIn.toggle()
        }
        }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) {result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) {result, error in
            if error != nil {
                print(error!.localizedDescription)
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
}
