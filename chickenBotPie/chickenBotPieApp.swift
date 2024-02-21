//
//  chickenBotPieApp.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/14/24.
//

import SwiftUI
import Firebase

@available(iOS 17.0, *)
@main
struct chickenBotPieApp: App {
    
    @StateObject var UserManager = UserManagement()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(UserManager: UserManager)
        }
    }
}
