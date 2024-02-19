//
//  MatchDetailedView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/19/24.
//

import SwiftUI

struct MatchDetailedView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let match: pastMatchData

    var body: some View {
        List {
            Section(header: Text("Match Information")) {
                Text("Scout Name: \(match.scoutname)")
                Text("Team Number: \(match.teamnumber)")
                Text("Match Number: \(match.matchnumber)")
                Text("Alliance: \(match.alliance)")
            }
            
            Section(header: Text("Autonomous")) {
                Text("Auto AMP Points: \(match.autoamppoints)")
                Text("Auto Speaker Points: \(match.autospeakerpoints)")
                Text("Auto Left Zone: \(match.autoleftzone ? "Yes" : "No")")
            }
            
            Section(header: Text("Teleop")) {
                Text("Tele AMP Points: \(match.teleamppoints)")
                Text("Tele Speaker Points: \(match.telespeakerpoints)")
                Text("Tele Speaker Amplified Points: \(match.telespeakeramplifiedpoints)")
                Text("Drops: \(match.drops)")
            }
            
            Section(header: Text("Endgame")) {
                Text("Climbed: \(match.climbed ? "Yes" : "No")")
                Text("Parked: \(match.parked ? "Yes" : "No")")
                Text("Harmony: \(match.harmony ? "Yes" : "No")")
                Text("Trap: \(match.trap)")
                Text("Number of Traps: \(match.numtraps)")
                Text("Offered Cooperation: \(match.offeredcoop ? "Yes" : "No")")
                Text("Did Cooperate: \(match.didcoop ? "Yes" : "No")")
            }
            
            Section(header: Text("Human Player")) {
                Text("AMP Mike: \(match.ampmike)")
                Text("Source Mike: \(match.sourcemike)")
                Text("Center Mike: \(match.centermike)")
            }
            
            Section(header: Text("Timestamp")) {
                Text("Timestamp: \(formatTimestamp(match.timestamp) ?? "Invalid Timestamp")")
            }
        }
        .listStyle(InsetGroupedListStyle())
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

