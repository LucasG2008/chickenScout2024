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
    
    // SIGN UP
    
    func signUp(email: String, username: String, password: String) async {
        guard let signUpURL = URL(string: "http://75.72.123.64:3082/signup") else {
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
    
    // SIGN IN
    
    func signOut() {
        self.loggedIn = false // wipes out user session and takes user back to login
        self.currentUser = nil // wipes out current user data model
    }
    
    // LOG IN
    
    func logIn(username: String, password: String) async {
        guard let signUpURL = URL(string: "http://75.72.123.64:3082/login") else {
            print("Error getting sign up url")
            
            return
        }
        
        let tempPushJSON = UserLogIn.init(username: username, password: password)
        if let encoded = try? JSONEncoder().encode(tempPushJSON) {
            
            var request = URLRequest(url: signUpURL)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded
            

            let task = URLSession.shared.dataTask(with: request) {
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
                            }
                        }
                    } catch {
                        print("Error parsing data: \(error.localizedDescription)")
                    }
                }
                
                
                print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding")
                //self.currentUser = User(id: data, fullname: <#T##String#>, password: <#T##String#>, email: <#T##String#>, matchesScouted: <#T##Int#>)
                
            }
            
            task.resume()
            
        }
    }
    
    // GUEST SIGN IN
    
    func guestSignIn(name: String, email: String) {
        
        // Create a guest user without needing a connection
        let guestUser = User(id: UUID().uuidString, fullname: name, password: "none", email: email, matchesScouted: 0)

        self.loggedIn = true

        self.currentUser = guestUser
    }

}
