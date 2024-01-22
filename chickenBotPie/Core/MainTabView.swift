//
//  MainTabView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/21/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            TeamView().tabItem {
                Text("Teams")
                Image(systemName: "person.3")
            }
            
            ScoutingView().tabItem {
                Text("Scouting")
                Image(systemName: "list.bullet")
            }
            
            InputView().tabItem {
                Text("Input")
                Image(systemName: "square.and.pencil")
            }
            
            ProfileView().tabItem {
                Text("Profile")
                Image(systemName: "person.circle")
                
            }
        }
    }
}

