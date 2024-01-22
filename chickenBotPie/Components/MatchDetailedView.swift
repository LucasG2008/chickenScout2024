//
//  MatchDetailedView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/19/24.
//

import SwiftUI

struct MatchDetailedView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let match: matchScoutData

    var body: some View {
        List {
            // Display detailed information for the match
            Text("Team: \(match.teamName)")
            Text("Scout: \(match.scout)")
            Text("Alliance: \(match.alliance)")
            Text("Auto Sequence: \(match.autoSequence.joined(separator: ", "))")
               .multilineTextAlignment(.trailing)
            Text("Teleop Sequence: \(match.teleopSequence.joined(separator: ", "))")
               .multilineTextAlignment(.trailing)
            Text("Drops: \(match.drops)")
            Text("Park: \(match.park)" as String)
            Text("Climbed: \(match.climbed)" as String)
            Text("Harmony: \(match.harmony)" as String)
            Text("Trap: \(match.trap)" as String)
            Text("High Notes: \(match.highNote)" as String)
            Text("Misses: \(match.highNoteMisses)")
            Text("Score: \(match.score)")
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
        .navigationTitle("Match Details")
    }
}

