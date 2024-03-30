//
//  DataManagement.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 2/13/24.
//

import Foundation
struct UsernamePush: Codable {
    var username: String
}

func saveDataLocally(matchData: matchScoutData) {
    // Convert match data to Data format (assuming MatchScoutData is Codable)
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(matchData)
        
        // Save data to UserDefaults or CoreData
        UserDefaults.standard.set(data, forKey: "savedMatchData")
    } catch {
        print("Error saving data locally: \(error)")
    }
}

class DataManager {
    
    func uploadMatchData(matchData: matchScoutData) async {
        
        guard let matchURL = URL(string: "http://98.59.100.219:3082/matchinput") else {
            print("Error getting match input URL")
            return
        }
        
        do {
            let encoded = try JSONEncoder().encode(matchData)
//            let stringData = String(data: encoded, encoding: .utf8) ?? "*unknown encoding"
//            print("Data to push:")
//            print(stringData)
            
            var request = URLRequest(url: matchURL) // create request
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                //print("Response status code: \(httpResponse.statusCode)")
            }
            
//            let responseString = String(data: data, encoding: .utf8) ?? "*unknown encoding"
//            print("Response data:")
//            print(responseString)
            
        } catch {
            print("Error encoding or uploading match data: \(error)")
        }
    }
    
    func uploadPitData(pitData: pitScoutData) async {
        
        guard let pitURL = URL(string: "http://98.59.100.219:3082/pitscoutinginput") else {
            print("Error getting match input URL")
            return
        }
        
        do {
            let encoded = try JSONEncoder().encode(pitData)
            let stringData = String(data: encoded, encoding: .utf8) ?? "*unknown encoding"
            print("Data to push:")
            print(stringData)
            
            var request = URLRequest(url: pitURL) // create request
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }
            
            let responseString = String(data: data, encoding: .utf8) ?? "*unknown encoding"
            print("Response data:")
            print(responseString)
            
        } catch {
            print("Error encoding or uploading pit data: \(error)")
        }
    }
    
    func fetchPastMatches() async throws -> [pastMatchData] {
        guard let pastMatchesURL = URL(string: "http://98.59.100.219:3082/pastmatchinput") else {
            throw NSError(domain: "FetchError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error getting past matches URL"])
        }
        
        var request = URLRequest(url: pastMatchesURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
//                print("Response status code: \(httpResponse.statusCode)")
            }
            
            let pastMatches = try JSONDecoder().decode([pastMatchData].self, from: data)
//            print("Response data:")
//            print(pastMatches)
            
            return pastMatches
        } catch {
            throw error
        }
    }
    
    func fetchPitData(teamNum: String) async throws -> pitScoutData {
        guard let pitsURL = URL(string: "http://98.59.100.219:3082/teambuilddata/\(teamNum)") else {
            throw NSError(domain: "FetchError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error getting pit data URL"])
        }
        
        var request = URLRequest(url: pitsURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
//            if let httpResponse = response as? HTTPURLResponse {
//                print("Response status code: \(httpResponse.statusCode)")
//            }
//            let responseString = String(data: data, encoding: .utf8) ?? "*unknown encoding"
//            print(responseString)
            
            let pits = try JSONDecoder().decode(pitScoutData.self, from: data)
            
            return pits
        } catch {
            throw error
        }
    }
    
    func fetchTeamData(teamNum: String) async throws -> teamAvgData {
        guard let teamDataURL = URL(string: "http://98.59.100.219:3082/teamaverages/\(teamNum)") else {
            print("Error getting team data URL")
            throw NSError(domain: "FetchError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error getting team avg URL"])
        }
        
        var request = URLRequest(url: teamDataURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        do {
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
//            if let httpResponse = response as? HTTPURLResponse {
//                print("Response status code: \(httpResponse.statusCode)")
//            }
//            
//            let responseString = String(data: data, encoding: .utf8) ?? "*unknown encoding"
//            print("Response data:")
//            print(responseString)
            
            let teamAvgs = try JSONDecoder().decode(teamAvgData.self, from: data)
            return teamAvgs
        } catch {
            throw error
        }
    }
    
    func fetchLeaderboard() async throws -> [scoutData] {
        guard let leaderBoardURL = URL(string: "http://98.59.100.219:3082/leaderboard") else {
            print("Error getting team data URL")
            throw NSError(domain: "FetchError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error getting leaderboard URL"])
        }
        
        var request = URLRequest(url: leaderBoardURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        do {
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
//            if let httpResponse = response as? HTTPURLResponse {
//                print("Response status code: \(httpResponse.statusCode)")
//            }
            
//            let responseString = String(data: data, encoding: .utf8) ?? "*unknown encoding"
//            print("Response data:")
//            print(responseString)
            
            let leaderboard = try JSONDecoder().decode([scoutData].self, from: data)
            return leaderboard
            
        } catch {
            throw error
        }
    }
    
    func fetchSchedule(fullname: String) async {
        
        guard let checkInURL = URL(string: "http://98.59.100.219:3082/scheduler/signin") else {
            print("Error getting scheduler ulr")
            return
        }
        var username = UsernamePush.init(username: fullname)
        do {
            let encoded = try JSONEncoder().encode(username)
            let stringData = String(data: encoded, encoding: .utf8) ?? "*unknown encoding"
            print("Data to push:")
            print(stringData)
            
            var request = URLRequest(url: checkInURL) // create request\
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }
            
            let responseString = String(data: data, encoding: .utf8) ?? "*unknown encoding"
            print("Response data:")
            print(responseString)
            
        } catch {
            print("Error fetching shedule: \(error)")
        }
    }
    
    func fetchScoutedPits() async throws -> [condensedPitScoutData] {
        guard let pitsScoutedURL = URL(string: "http://98.59.100.219:3082/teams/pitsscouted") else {
            print("Error getting pits scouted URL")
            throw NSError(domain: "FetchError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error getting pits scouted URL"])
        }
        
        var request = URLRequest(url: pitsScoutedURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        do {
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }
            
            let responseString = String(data: data, encoding: .utf8) ?? "*unknown encoding"
            print("Response data:")
            print(responseString)
            
            let pitsScouted = try JSONDecoder().decode([condensedPitScoutData].self, from: data)
            return pitsScouted
            
        } catch {
            throw error
        }
    }
}
