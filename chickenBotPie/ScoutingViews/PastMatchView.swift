//
//  PastMatchView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/22/24.
//

import SwiftUI

struct PastMatchView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedMatch: matchScoutData?
    
    @State private var searchText = ""
    
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter
        }()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(filteredMatches.sorted(by: { $0.submissionTime > $1.submissionTime }), id: \.submissionTime) { match in
                        NavigationLink(
                            destination: MatchDetailedView(match: match),
                            label: {
                                HStack {
                                    Text("\(match.teamName)")
                                    Spacer()
                                    Text("\(dateFormatter.string(from: match.submissionTime))")
                                }
                            }
                        )
                        .tag(match)
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
    }
    
    var filteredMatches: [matchScoutData] {
        if searchText.isEmpty {
            return dataManager.matches
        } else {
            return dataManager.matches.filter { match in
                dateFormatter.string(from: match.submissionTime).localizedCaseInsensitiveContains(searchText) ||
                    match.teamName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

#Preview {
    PastMatchView()
}
