//
//  InputView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/20/24.
//

import SwiftUI

struct LoginInputView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecuredField = false
    
    @State private var showPassword: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text(title)
                .foregroundColor(colorScheme == .dark ? .white : Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecuredField {
                
                ZStack(alignment: .trailing) {
                    Group {
                        if !showPassword {
                            SecureField(placeholder, text: $text)
                                .font(.system(size: 14))
                                .foregroundColor(colorScheme == .dark ? .white : Color(.darkGray))
                        } else {
                            TextField(placeholder, text: $text)
                                .font(.system(size: 14))
                                .foregroundColor(colorScheme == .dark ? .white : Color(.darkGray))
                        }
                    }.padding(.trailing, 32)

                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: !self.showPassword ? "eye.slash" : "eye")
                            .accentColor(.gray)
                    }
                }

            } else {
                if title == "Email Address" {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 14))
                        .foregroundColor(colorScheme == .dark ? .white : Color(.darkGray))
                        .textContentType(.emailAddress)
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 14))
                        .foregroundColor(colorScheme == .dark ? .white : Color(.darkGray))
                }
            }
            
            Divider()
        }
    }
}

#Preview {
    LoginInputView(text: .constant(""), title: "Password", placeholder: "password", isSecuredField: true)
}
