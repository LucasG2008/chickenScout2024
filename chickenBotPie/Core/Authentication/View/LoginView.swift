//
//  LoginView2.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/20/24.
//

import SwiftUI

struct LoginView: View, LoginAuthenticationFormProtocol {
    @State internal var email = ""
    @State internal var password = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            VStack {
                // image
                if colorScheme == .light {
                    Image("chicken-light")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                } else {
                    Image("chicken-dark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                }
                
                // Welcome text
                Text("Login")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 36, design: .rounded))
                    .fontWeight(.bold)
                    .padding(.bottom, 25)
                    .padding([.leading, .trailing], 10)
                
                
                
                // Form fields
                VStack(spacing: 24) {
                    LoginInputView(text: $email,
                                   title: "Email Address",
                                   placeholder: "name@example.com")
                    .autocapitalization(.none)
                    
                    LoginInputView(text: $password,
                                   title: "Password",
                                   placeholder: "Enter your password",
                                   isSecuredField: true)
                }
                .padding(.horizontal)
                
                // Sign in button
                Button {
                    Task {
                        viewModel.signIn(withEmail: email, password: password) { result in
                            switch result {
                            case .success:
                                // Handle successful login
                                print("Login successful")
                            case .failure(let error):
                                // Handle login failure
                                print("Login failed with error: \(error.localizedDescription)")
                                showAlert = true
                                alertMessage = "Login failed. \(error.localizedDescription)"
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .background(
                    LinearGradient(gradient: colorScheme == .dark ? Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]) : Gradient(colors: [Color(hex: "#0047AB").opacity(1), Color(hex: "#0047AB").opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                )
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                HStack {
                    VStack{ Divider() }
                    Text("or")
                        .font(.system(size: 14, design: .rounded))
                    VStack { Divider() }
                }
                
                // Google sign in
                Button {
                    Task {
                        let success = await viewModel.signInWithGoogle()
                        if success {
                            // Handle successful sign-in
                            print("User signed in with Google")
                        } else {
                            // Handle sign-in failure
                            print("Failed to sign in with Google")
                        }
                    }
                } label: {
                    Text("Sign in with Google")
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(alignment: .leading) {
                            Image("Google")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, alignment: .center)
                        }
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
            }
            .navigationBarHidden(true)
            .padding(.horizontal)
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
    
    
    var formIsValid: Bool {
        return !email.isEmpty && email.contains("@") && password.count > 5
    }
}

#Preview {
    LoginView()
}
