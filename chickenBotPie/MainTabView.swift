//
//  MainTabView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/21/24.
//

import SwiftUI

struct MainTabView: View {
    
    @ObservedObject var UserManager: UserManagement
    
    var body: some View {
        TabView {
            TeamView().tabItem {
                Text("Teams")
                Image(systemName: "person.3")
            }
            
            ScoutingView(UserManager: UserManager).tabItem {
                Text("Scouting")
                Image(systemName: "list.bullet")
            }
            
            ProfileView(UserManager: UserManager).tabItem {
                Text("Profile")
                Image(systemName: "person.circle")
                
            }
        }
    }
}

