//
//  TBAManager.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 2/3/24.
//

import Foundation

class TBAManager: ObservableObject {
    @Published var teams: [BlueAllianceTeam] = []

        func requestAllTeamsFromBlueAlliance() async {
            var allTeams: [BlueAllianceTeam] = []
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

                    let fetchedTeams = try JSONDecoder().decode([BlueAllianceTeam].self, from: data)

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

            self.teams = allTeams
        }
    }

