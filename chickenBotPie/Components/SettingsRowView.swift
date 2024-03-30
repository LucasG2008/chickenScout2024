//
//  SettingsRowView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/20/24.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    @State private var willMoveToNextScreen = false
    
    var body: some View {
        
        if title == "Version" {
            NavigationStack{
                HStack(spacing: 12) {
                    Image(systemName: imageName)
                        .imageScale(.small)
                        .font(.title)
                        .foregroundStyle(tintColor)
                        .background(
                                    NavigationLink("", destination: Egg())
                                        .opacity(0)
                                )
                    Text(title)
                        .font(.subheadline)
                    
                    //.foregroundStyle(.black)
                }
            }
                
        } else {
            
            HStack(spacing: 12) {
                Image(systemName: imageName)
                    .imageScale(.small)
                    .font(.title)
                    .foregroundStyle(tintColor)
                
                Text(title)
                    .font(.subheadline)
                //.foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    SettingsRowView(imageName: "gear", title: "version", tintColor: Color(.systemGray))
}
