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
    @ObservedObject var UserManager: UserManagement
    @State private var dataManager = DataManager()
    
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
                ScrollView{
                    Text("Scouting is an extremely important role at competitions because the data will help us make the best decisions for who to bring onto our alliance in playoffs. With your quality scouting data, we will have more information about the other teams than provided by ranking points, so we will be able to create the strongest possible alliance using your data. We can also determine which other team’s have strategies that will work with ours, so that our alliance will work well together in playoffs and we are more likely to win.")
                        .padding()
                }
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
                await UserManager.getMatchesScouted(name: UserManager.currentUser?.fullname ?? "none")
            }
        }
    }
}

#Preview {
    HomeView(UserManager: UserManagement())
}
