//
//  ScoutingView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/19/24.
//

import SwiftUI

struct ScoutingView: View {
    
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedMatch: matchScoutData?
    
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter
        }()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.matches.sorted(by: { $0.submissionTime > $1.submissionTime }), id: \.submissionTime) { match in
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
            .navigationTitle("Matches")
        }
    }
}

#Preview {
    ScoutingView()
}
