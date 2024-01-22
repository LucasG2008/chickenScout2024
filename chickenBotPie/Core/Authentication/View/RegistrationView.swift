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
            
            Text("Create an Account")
                .multilineTextAlignment(.center)
                .font(.system(size: 30, design: .rounded))
                .fontWeight(.bold)
                .padding(.bottom, 5)
                .padding([.leading, .trailing], 10)
            
            
            VStack (spacing: 24) {
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
            .padding(.top, 12)
            
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
            .background(Color(.systemBlue))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top, 14)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
            .padding(.bottom, 20)
        }
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
