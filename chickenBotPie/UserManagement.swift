//
//  UserManagement.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 2/6/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let password: String
    let email: String
    let matchesScouted: Int
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Lucas Granucci", password: "password123", email: "lucasgranucci08@gmail.com", matchesScouted: 5)
}

@MainActor
class UserManagement: ObservableObject {
    @Published var loggedIn = false
    @Published var currentUser: User?
    
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var matchesScouted = 0
    
    var dict_userid = ""
    var dict_username = ""
    var dict_password = ""
    var dict_email = ""
    var dict_matchesScouted = 0
    
    // Add properties for storing persistent authentication state
    private let userDefaults = UserDefaults.standard
    private let loggedInKey = "loggedIn"
    private let userIdKey = "userId"
    private let userFullname = "userFullname"
    private let userPassword = "userPassword"
    private let userEmail = "userEmail"
    private let userMatchesScouted = 0
    
    init() {
        // Check for stored authentication state
        if userDefaults.bool(forKey: loggedInKey) {
            let savedUserId = userDefaults.string(forKey: userIdKey) ?? ""
            let savedUserFullname = userDefaults.string(forKey: userFullname) ?? ""
            let savedUserPassword = userDefaults.string(forKey: userPassword) ?? ""
            let savedUserEmail = userDefaults.string(forKey: userEmail) ?? ""
            let savedUserMatchesScouted = userDefaults.integer(forKey: String(userMatchesScouted))
            
            currentUser = User(id: savedUserId, fullname: savedUserFullname, password: savedUserPassword, email: savedUserEmail, matchesScouted: savedUserMatchesScouted)
            loggedIn = true
        }
    }
    
    // SIGN UP
    
    func signUp(email: String, username: String, password: String) async {
        guard let signUpURL = URL(string: "http://98.59.100.219:3082/signup") else {
            print("Error getting sign up url")
            
            return
        }
        
        let tempPushJSON = UserSignUp.init(username: username, password: password, email: email)
        if let encoded = try? JSONEncoder().encode(tempPushJSON) {
            
            var request = URLRequest(url: signUpURL)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded
            

            let task = URLSession.shared.dataTask(with: request) { [self]
                data, response, error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                guard let data = data else {
                    return
                }

                let stringData = String(data: data, encoding: .utf8) ?? "*unknown encoding"
                
                if let jsonData = stringData.data(using: .utf8) {
                    do {
                        if let dataDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                            DispatchQueue.main.async {
                                if let userid = dataDict["uuid"] {
                                    self.dict_userid = userid as! String
                                }
                                if let username = dataDict["username"] {
                                    self.dict_username = username as! String
                                }
                                if let password = dataDict["password"] {
                                    self.dict_password = password as! String
                                }
                                if let email = dataDict["email"] {
                                    self.dict_email = email as! String
                                }
                                if let matchesScouted = dataDict["matchesscouted"] {
                                    self.dict_matchesScouted = matchesScouted as! Int
                                }
                                
                                self.currentUser = User(id: self.dict_userid, fullname: self.dict_username, password: self.dict_password, email: self.dict_email, matchesScouted: self.dict_matchesScouted)
                                self.loggedIn = true
                                
                                // Save authentication state
                                self.userDefaults.set(true, forKey: self.loggedInKey)
                                self.userDefaults.set(self.currentUser?.id, forKey: self.userIdKey)
                                self.userDefaults.set(self.currentUser?.fullname, forKey: self.userFullname)
                                self.userDefaults.set(self.currentUser?.password, forKey: self.userPassword)
                                self.userDefaults.set(self.currentUser?.email, forKey: self.userEmail)
                                self.userDefaults.set(self.currentUser?.matchesScouted, forKey: String(self.userMatchesScouted))
                            }
                        }
                    } catch {
                        print("Error parsing data: \(error.localizedDescription)")
                    }
                }
                
            }
            
            task.resume()
            
        }
    }
    
    // SIGN OUT
    
    func signOut() {
        self.loggedIn = false
        self.currentUser = nil
        
        // Clear stored authentication state
        userDefaults.set(false, forKey: loggedInKey)
        userDefaults.set("", forKey: userIdKey)
        userDefaults.set("", forKey: userFullname)
        userDefaults.set("", forKey: userPassword)
        userDefaults.set("", forKey: userEmail)
        userDefaults.set(0, forKey: String(userMatchesScouted))
    }
    
    // LOG IN
    
    func logIn(username: String, password: String) async {
        guard let signUpURL = URL(string: "http://98.59.100.219:3082/login") else {
            print("Error getting sign up url")
            
            return
        }
        
        let tempPushJSON = UserLogIn.init(username: username, password: password)
        if let encoded = try? JSONEncoder().encode(tempPushJSON) {
            
            var request = URLRequest(url: signUpURL)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded
            

            let task: Void = URLSession.shared.dataTask(with: request) {
                data, response, error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                guard let data = data else {
                    return
                }
                
                let stringData = String(data: data, encoding: .utf8) ?? "*unknown encoding"
                
                if let jsonData = stringData.data(using: .utf8) {
                    do {
                        if let dataDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                            DispatchQueue.main.async {
                                if let userid = dataDict["uuid"] {
                                    self.dict_userid = userid as! String
                                }
                                if let username = dataDict["username"] {
                                    self.dict_username = username as! String
                                }
                                if let password = dataDict["password"] {
                                    self.dict_password = password as! String
                                }
                                if let email = dataDict["email"] {
                                    self.dict_email = email as! String
                                }
                                if let matchesScouted = dataDict["matchesscouted"] {
                                    self.dict_matchesScouted = matchesScouted as! Int
                                }
                                
                                self.currentUser = User(id: self.dict_userid, fullname: self.dict_username, password: self.dict_password, email: self.dict_email, matchesScouted: self.dict_matchesScouted)
                                self.loggedIn = true
                                
                                // Save authentication state
                                self.userDefaults.set(true, forKey: self.loggedInKey)
                                self.userDefaults.set(self.currentUser?.id, forKey: self.userIdKey)
                                self.userDefaults.set(self.currentUser?.fullname, forKey: self.userFullname)
                                self.userDefaults.set(self.currentUser?.password, forKey: self.userPassword)
                                self.userDefaults.set(self.currentUser?.email, forKey: self.userEmail)
                                self.userDefaults.set(self.currentUser?.matchesScouted, forKey: String(self.userMatchesScouted))
                            }
                        }
                    } catch {
                        print("Error parsing data: \(error.localizedDescription)")
                    }
                }
                
            }.resume()
            
        }
        
    }
    
    // GUEST SIGN IN
    
    func guestSignIn(name: String, email: String) {
        
        // Create a guest user without needing a connection
        let guestUser = User(id: UUID().uuidString, fullname: name, password: "none", email: email, matchesScouted: 0)

        self.loggedIn = true
        self.currentUser = guestUser
        
        userDefaults.set(true, forKey: loggedInKey)
        userDefaults.set(guestUser.id, forKey: userIdKey)
        userDefaults.set(guestUser.fullname, forKey: userFullname)
        userDefaults.set(guestUser.password, forKey: userPassword)
        userDefaults.set(guestUser.email, forKey: userEmail)
        userDefaults.set(guestUser.matchesScouted, forKey: String(userMatchesScouted))
    }

}
