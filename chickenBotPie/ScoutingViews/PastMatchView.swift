//
//  PastMatchView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/22/24.
//

import SwiftUI

func formatTimestamp(_ timestamp: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    if let date = dateFormatter.date(from: timestamp) {
        dateFormatter.dateFormat = "M-d-Y HH:mm"
        return dateFormatter.string(from: date)
    } else {
        return nil
    }
}

struct PastMatchView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var dataManager = DataManager()
    
    @State private var selectedMatch: pastMatchData?
    @State private var pastMatches: [pastMatchData] = []
    
    @State private var searchText = ""
    
    var filteredMatches: [pastMatchData] {
            if searchText.isEmpty {
                return pastMatches
            } else {
                return pastMatches.filter { match in
                    "\(match.teamnumber)".contains(searchText) || "\(match.matchnumber)".contains(searchText)
                }
            }
        }
    
    var body: some View {
        NavigationView {
            List(filteredMatches, id: \.self) { match in
                NavigationLink(destination: MatchDetailedView(match: match)) {
                    VStack(alignment: .leading) {
                        Text("Match Number: \(match.matchnumber)")
                            .font(.headline)
                        Text("Team Number: \(match.teamnumber)")
                            .font(.subheadline)
                        if let formattedTimestamp = formatTimestamp(match.timestamp) {
                            Text("Submission Data: \(formattedTimestamp)")
                                .font(.subheadline)
                        } else {
                            Text("Invalid Timestamp")
                                .font(.subheadline)
                                .foregroundColor(.red) // Optionally indicate an invalid timestamp
                        }
                        Text("Scout Name: \(match.scoutname)")
                            .font(.subheadline)
                    }
                }
            }
            .searchable(text: $searchText)
            .scrollContentBackground(.hidden)
            .background(
                Group {
                    if colorScheme == .light {
                        LinearGradient(gradient: Gradient(colors: [Color.lightBlueStart, Color.lightBlueEnd]), startPoint: .top, endPoint: .bottom)
                    } else {
                        LinearGradient(gradient: Gradient(colors: [Color.darkBlueStart, Color.darkBlueEnd]), startPoint: .top, endPoint: .bottom)
                    }
                }
                .edgesIgnoringSafeArea(.all))
            .navigationTitle("Match Data")
        }
        .onAppear {
            Task {
                do {
                    pastMatches = try await dataManager.fetchPastMatches()
                } catch {
                    print("Error fetching past matches: \(error)")
                }
            }
        }
    }
}
