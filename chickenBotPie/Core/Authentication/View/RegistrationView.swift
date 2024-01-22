//
//  RegistrationView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/20/24.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image("chicken-image")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 220)
                .padding(.vertical, 32)
            
            
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
                
                LoginInputView(text: $confirmPassword,
                               title: "Confirm Password",
                               placeholder: "Confirm your pasword",
                               isSecuredField: true)
                
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button {
                print("log user in...")
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
            .cornerRadius(10)
            .padding(.top, 24)
            
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

        }
    }
}

#Preview {
    RegistrationView()
}
