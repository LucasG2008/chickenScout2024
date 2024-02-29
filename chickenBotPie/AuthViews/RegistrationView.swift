//
//  RegistrationView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/20/24.
//

import SwiftUI

struct RegistrationView: View { 
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var UserManager: UserManagement
    
    @State internal var email = ""
    @State internal var fullname = ""
    @State internal var password = ""
    @State internal var confirmPassword = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
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
                        await UserManager.signUp(email: email, username: fullname, password: password)
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
    RegistrationView(UserManager: UserManagement())
}
