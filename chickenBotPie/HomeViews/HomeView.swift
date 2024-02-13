//
//  HomeView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 2/12/24.
//
import SwiftUI

struct HomeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var teamsViewModel = TBAManager()
    
    
    var body: some View {
        
        // navigation stack to display all the robotics teams
        NavigationStack {
            
            VStack {
                if colorScheme == .light {
                    Image("chicken-light")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                } else {
                    Image("chicken-dark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                }
                // Welcome text
                Text("Welcome to ChickenScout!")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 36, design: .rounded))
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                    .padding([.leading, .trailing], 10)

                Text("More info on ChickenScout and how to use it here")
                    .padding()
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
        .task {
            Task {
                await teamsViewModel.fetchTeamsForEvent(eventCode: "All")
            }
        }
    }
}

#Preview {
    HomeView()
}
