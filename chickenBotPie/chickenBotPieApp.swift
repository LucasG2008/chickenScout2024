//
//  chickenBotPieApp.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/14/24.
//

import SwiftUI
import Firebase

@main
struct chickenBotPieApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    @StateObject var UserManager = UserManagement()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(UserManager: UserManager)
                .environmentObject(viewModel)
        }
    }
}
