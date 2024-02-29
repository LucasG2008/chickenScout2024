////
////  AuthViewModel.swift
////  chickenBotPie
////
////  Created by Lucas Granucci on 1/20/24.
////
//
//import Foundation
//
//import FirebaseFirestoreSwift
//import FirebaseAuth
//import Firebase
//import GoogleSignIn
//
//protocol LoginAuthenticationFormProtocol {
//    var email: String { get set }
//    var password: String { get set }
//    var formIsValid: Bool { get }
//}
//
//protocol SignupAuthenticationFormProtocol {
//    var email: String { get set }
//    var password: String { get set }
//    var fullname: String { get set }
//    var confirmPassword: String { get set }
//    var formIsValid: Bool { get }
//}
//
//@MainActor
//class AuthViewModel: ObservableObject {
//    @Published var errorMessage: String = ""
//    @Published var userSession: Any?
//    @Published var currentUser: User?
//    
//    
//    enum AuthError: Error {
//        case emailAlreadyInUse
//        // Add more error cases as needed
//    }
//    
//    enum AuthenticationError: Error {
//      case tokenError(message: String)
//    }
//    
//    init() {
//        self.userSession = Auth.auth().currentUser
//        
//        Task {
//            await fetchUser()
//        }
//    }
//    
//    func signIn(withEmail email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        Task {
//            do {
//                let result = try await Auth.auth().signIn(withEmail: email, password: password)
//                self.userSession = result.user
//                await fetchUser()
//                completion(.success(()))
//            } catch {
//                completion(.failure(error))
//                print("DEBUG: Failed to log in with error \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    func createUser(withEmail email: String, password: String, fullname: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        Task {
//            do {
//                let result = try await Auth.auth().createUser(withEmail: email, password: password)
//                self.userSession = result.user
//                let user = User(id: result.user.uid, fullname: fullname, password: "none", email: email, matchesScouted: 0)
//                let encodedUser = try Firestore.Encoder().encode(user)
//                try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
//                await fetchUser()
//                completion(.success(()))
//            } catch {
//                completion(.failure(error))
//                print("DEBUG: Failed to create user with error \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    func signOut() {
//        do {
//            try Auth.auth().signOut() // signs out on backend
//            self.userSession = nil // wipes out user session and takes user back to login
//            self.currentUser = nil // wipes out current user data model
//        } catch {
//            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
//        }
//    }
//    
//    func deleteAccount() {
//            guard let currentUser = Auth.auth().currentUser else { return }
//
//            // Get the user's UID before the account deletion
//            let uid = currentUser.uid
//            
//            currentUser.delete { error in
//                if let error = error {
//                    print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
//                } else {
//                    // Account successfully deleted
//                    self.deleteUserData(uid: uid)
//                }
//            }
//        }
//
//        private func deleteUserData(uid: String) {
//            // Delete user data from Firestore
//            Firestore.firestore().collection("users").document(uid).delete { error in
//                if let error = error {
//                    print("DEBUG: Failed to delete user data with error \(error.localizedDescription)")
//                } else {
//                    // User data successfully deleted
//                    self.signOut() // Sign out the user after account deletion
//                }
//            }
//        }
//    
//    func fetchUser() async {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        
//        do {
//            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
//            
//            if snapshot.exists {
//                self.currentUser = try? snapshot.data(as: User.self)
//            } else {
//                // Handle the case when user data is not found
//                print("User data not found.")
//            }
//        } catch {
//            // Handle the error when fetching user data fails
//            print("Failed to fetch user data with error: \(error.localizedDescription)")
//        }
//    }
//    
//}
//
//extension AuthViewModel {
//    func signInWithGoogle() async -> Bool {
//        guard let clientID = FirebaseApp.app()?.options.clientID else {
//            fatalError("No client id found")
//        }
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//        
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let window = windowScene.windows.first,
//              let rootViewController = window.rootViewController else {
//            print("There is no root view controller")
//            return false
//        }
//        
//        do {
//            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
//            let user = userAuthentication.user
//            guard let idToken = user.idToken else {
//                throw AuthenticationError.tokenError(message: "ID token missing")
//            }
//            let accessToken = user.accessToken
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
//            
//            let result = try await Auth.auth().signIn(with: credential)
//            let firebaseUser = result.user
//            self.userSession = result.user
//            
//            let newUser = User(id: result.user.uid, fullname: firebaseUser.displayName ?? "unkown", password: "none", email: firebaseUser.email ?? "unknown", matchesScouted: 0)
//            let encodedUser = try Firestore.Encoder().encode(newUser)
//            try await Firestore.firestore().collection("users").document(newUser.id).setData(encodedUser)
//            
//            await fetchUser()
//            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
//            return true
//        } catch {
//            print(error.localizedDescription)
//            errorMessage = error.localizedDescription
//            return false
//        }
//    }
//}
//
//extension AuthViewModel {
//    func guestSignIn(name: String, email: String) {
//        // Create a guest user without involving Firebase authentication
//        let guestUser = User(id: UUID().uuidString, fullname: name, password: "none", email: email, matchesScouted: 0)
//
//        self.userSession = guestUser
//
//        self.currentUser = guestUser
//    }
//}
