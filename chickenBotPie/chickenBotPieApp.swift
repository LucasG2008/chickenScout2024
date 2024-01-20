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
    @StateObject var dataManager = DataManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(dataManager)
        }
    }
}
