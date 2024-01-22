//
//  ScoutingView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/19/24.
//

import SwiftUI

struct ScoutingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
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
            .navigationTitle("Matches")
        }
    }
}

#Preview {
    ScoutingView()
}
