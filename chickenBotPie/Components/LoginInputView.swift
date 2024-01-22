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
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text(title)
                .foregroundColor(colorScheme == .dark ? .white : Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecuredField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .foregroundColor(colorScheme == .dark ? .white : Color(.darkGray))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .foregroundColor(colorScheme == .dark ? .white : Color(.darkGray))
            }
            
            Divider()
        }
    }
}

#Preview {
    LoginInputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
}
