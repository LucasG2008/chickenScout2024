//
//  TBAManager.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 2/3/24.
//

import Foundation

class TBAManager: ObservableObject {
    @Published var allTeams: [QuickTeamView] = []
    @Published var mndu2Teams: [QuickTeamView] = []
    @Published var wilaTeams: [QuickTeamView] = []
    
    func requestAllTeamsFromBlueAlliance() async {
        var allTeams: [QuickTeamView] = []
        var page = 0 // Start with the first page
        
        while true {
            guard let blueAllianceTeamsURL = URL(string: "https://www.thebluealliance.com/api/v3/teams/\(page)") else {
                return
            }
            
            var request = URLRequest(url: blueAllianceTeamsURL)
            request.httpMethod = "GET"
            request.addValue("OcfTAuwiy7dvQouocBbQFTstVLeDWUeMF5DoZo4catY50cPSWlGjiGHP1VOiH74A", forHTTPHeaderField: "X-TBA-Auth-Key")
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Error: Invalid response")
                    return
                }
                
                let fetchedTeams = try JSONDecoder().decode([QuickTeamView].self, from: data)
                
                if fetchedTeams.isEmpty {
                    // No more teams, break the loop
                    break
                }
                
                allTeams.append(contentsOf: fetchedTeams)
                page += 1
            } catch {
                print("Error fetching teams from page \(page): \(error.localizedDescription)")
                break
            }
        }
        
        self.allTeams = allTeams
    }

    func fetchEventTeams(eventCode: String) async {
        guard let eventURL = URL(string: "http://75.72.123.64:3082/fetchteams\(eventCode)") else {
            print("Error getting event url")
            
            return
        }
        
        var request = URLRequest(url: eventURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Invalid response")
                return
            }
            
            let fetchedTeams = try JSONDecoder().decode([QuickTeamView].self, from: data)
            
            if eventCode == "mndu2" {
                self.mndu2Teams = fetchedTeams
            } else if eventCode == "wila" {
                self.wilaTeams = fetchedTeams
            }
            
        } catch {
            print("Error fetching teams: \(error.localizedDescription)")
        }
    }
    
    func fetchTeamsForEvent(eventCode: String) async {
        switch eventCode {
        case "2024mndu2":
            if mndu2Teams.isEmpty {
                await fetchEventTeams(eventCode: "mndu2")
            }
        case "2024wila":
            if wilaTeams.isEmpty {
                await fetchEventTeams(eventCode: "wila")
            }
        case "All":
            if allTeams.isEmpty {
                await requestAllTeamsFromBlueAlliance()
            }
        default:
            break
        }
    }

}
