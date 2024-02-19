//
//  GuestLoginView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/23/24.
//

import SwiftUI

struct GuestLoginView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var UserManager: UserManagement
    
    @State internal var name = ""
    @State internal var email = ""
    
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
                Text("Guest Sign In")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 36, design: .rounded))
                    .fontWeight(.bold)
                    .padding(.bottom, 25)
                    .padding([.leading, .trailing], 10)
                
                // Form fields
                VStack(spacing: 24) {
                    LoginInputView(text: $name,
                                   title: "Guest Name",
                                   placeholder: "Elliott Burrows")
                    
                    LoginInputView(text: $email,
                                   title: "Email Address",
                                   placeholder: "name@example.com")

                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Sign in button
                Button {
                    UserManager.guestSignIn(name: name, email: email)
                } label: {
                    HStack {
                        Text("SIGN IN AS GUEST")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .background(
                    LinearGradient(gradient: colorScheme == .dark ? Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]) : Gradient(colors: [Color(hex: "#0047AB").opacity(1), Color(hex: "#0047AB").opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(10)
                .padding(.top, 24)

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
        return !email.isEmpty && email.contains("@") && name.count > 2
    }
    
}

#Preview {
    GuestLoginView(UserManager: UserManagement())
}
