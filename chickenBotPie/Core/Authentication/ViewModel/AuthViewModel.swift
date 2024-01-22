//
//  AuthViewModel.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/20/24.
//

import Foundation

import FirebaseFirestoreSwift
import Firebase
import FirebaseAuth

protocol LoginAuthenticationFormProtocol {
    var email: String { get set }
    var password: String { get set }
    var formIsValid: Bool { get }
}

protocol SignupAuthenticationFormProtocol {
    var email: String { get set }
    var password: String { get set }
    var fullname: String { get set }
    var confirmPassword: String { get set }
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    enum AuthError: Error {
        case emailAlreadyInUse
        // Add more error cases as needed
    }
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                self.userSession = result.user
                await fetchUser()
                completion(.success(()))
            } catch {
                completion(.failure(error))
                print("DEBUG: Failed to log in with error \(error.localizedDescription)")
            }
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                self.userSession = result.user
                let user = User(id: result.user.uid, fullname: fullname, email: email)
                let encodedUser = try Firestore.Encoder().encode(user)
                try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
                await fetchUser()
                completion(.success(()))
            } catch {
                completion(.failure(error))
                print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // signs out on backend
            self.userSession = nil // wipes out user session and takes user back to login
            self.currentUser = nil // wipes out current user data model
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
            guard let currentUser = Auth.auth().currentUser else { return }

            // Get the user's UID before the account deletion
            let uid = currentUser.uid
            
            currentUser.delete { error in
                if let error = error {
                    print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
                } else {
                    // Account successfully deleted
                    self.deleteUserData(uid: uid)
                }
            }
        }

        private func deleteUserData(uid: String) {
            // Delete user data from Firestore
            Firestore.firestore().collection("users").document(uid).delete { error in
                if let error = error {
                    print("DEBUG: Failed to delete user data with error \(error.localizedDescription)")
                } else {
                    // User data successfully deleted
                    self.signOut() // Sign out the user after account deletion
                }
            }
        }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            
            if snapshot.exists {
                self.currentUser = try? snapshot.data(as: User.self)
            } else {
                // Handle the case when user data is not found
                print("User data not found.")
            }
        } catch {
            // Handle the error when fetching user data fails
            print("Failed to fetch user data with error: \(error.localizedDescription)")
        }
    }
    
}
