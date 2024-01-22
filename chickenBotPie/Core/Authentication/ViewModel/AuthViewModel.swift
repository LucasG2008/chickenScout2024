//
//  AuthViewModel.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/20/24.
//

import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        
    }
}
