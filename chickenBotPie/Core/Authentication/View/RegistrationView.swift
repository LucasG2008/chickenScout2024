//
//  RegistrationView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/20/24.
//

import SwiftUI

struct RegistrationView: View, SignupAuthenticationFormProtocol {
    
    @State internal var email = ""
    @State internal var fullname = ""
    @State internal var password = ""
    @State internal var confirmPassword = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // image
                //if colorScheme == .light {
                //    Image("chicken-light")
                //        .resizable()
                //        .aspectRatio(contentMode: .fit)
                //        .frame(width: 90, height: 90)
                //} else {
                //    Image("chicken-dark")
                //        .resizable()
                //        .aspectRatio(contentMode: .fit)
                //        .frame(width: 90, height: 90)
                //}
                
                Text("Create an Account")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 35, design: .rounded))
                    .fontWeight(.bold)
                    .padding(.bottom, 25)
                    .padding([.leading, .trailing], 10)
                
                
                VStack (spacing: 22) {
                    LoginInputView(text: $email,
                                   title: "Email Address",
                                   placeholder: "name@example.com")
                    .autocapitalization(.none)
                    
                    LoginInputView(text: $fullname,
                                   title: "Full Name",
                                   placeholder: "Enter your name")
                    
                    LoginInputView(text: $password,
                                   title: "Password",
                                   placeholder: "Enter your pasword",
                                   isSecuredField: true)
                    
                    ZStack(alignment: .trailing) {
                        LoginInputView(text: $confirmPassword,
                                       title: "Confirm Password",
                                       placeholder: "Confirm your pasword",
                                       isSecuredField: true)
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(.systemRed))
                            }
                        }
                    }
                    
                    
                }
                .padding(.horizontal)
                
                
                Button {
                    Task {
                        viewModel.createUser(withEmail: email, password: password, fullname: fullname) { result in
                            switch result {
                            case .success:
                                //print("User created successfully")
                                break
                            case .failure(let error):
                                // Handle user creation failure
                                //print("User creation failed with error: \(error.localizedDescription)")
                                showAlert = true
                                alertMessage = "User creation failed. \(error.localizedDescription)"
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text("SIGN UP")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(
                    LinearGradient(gradient: colorScheme == .dark ? Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]) : Gradient(colors: [Color(hex: "#0047AB").opacity(1), Color(hex: "#0047AB").opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                )
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 14)
                
                HStack {
                    VStack{ Divider() }
                    Text("or")
                        .font(.system(size: 14, design: .rounded))
                    VStack { Divider() }
                }
                .padding([.leading, .trailing])
                
                // Google account creation
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
                    Text("Sign up with Google")
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
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                .buttonStyle(.bordered)
                .padding(.bottom, 10)
                
                Spacer()
                
            }
            .navigationBarHidden(true)
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
        return !email.isEmpty
        && email.contains("@")
        && password.count > 5
        && !fullname.isEmpty
        && confirmPassword == password
    }
}

#Preview {
    RegistrationView()
}
