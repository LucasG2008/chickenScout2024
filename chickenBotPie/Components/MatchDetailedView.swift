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
    
    var gameScore: Int {
        var totalScore = 0
        
        // Add auto and teleop scores
        totalScore += match.autoamppoints
        totalScore += match.autospeakerpoints
        totalScore += match.autoleftzone ? 2 : 0
        
        totalScore += match.teleamppoints
        totalScore += match.telespeakerpoints
        totalScore += match.telespeakeramplifiedpoints
        
        totalScore += match.climbed ? 3 : 0
        totalScore += match.parked ? 2 : 0
        totalScore += match.harmony ? 1 : 0
        
        // Spotlight data
        if match.ampmike == "Score" {
            totalScore += 1
        }
        if match.sourcemike == "Score" {
            totalScore += 1
        }
        if match.centermike == "Score" {
            totalScore += 1
        }
        
        
        if match.ampmike == "Score w/ harmony" {
            totalScore += 2
        }
        if match.sourcemike == "Score w/ harmony" {
            totalScore += 2
        }
        if match.centermike == "Score w/ harmony" {
            totalScore += 2
        }
        
        // Check if trap is "Yes"
        if match.trap == "Yes" {
            totalScore += (5 * match.numtraps)
        }
        
        return totalScore
    }

    var body: some View {
        List {
            Section(header: Text("Match Information")) {
                Text("Scout Name: \(match.scoutname)")
                Text(verbatim: "Team Number: \(match.teamnumber)")
                Text("Match Number: \(match.matchnumber)")
                Text("Alliance: \(match.alliance)")
                Text("Total Scored Points: \(gameScore)")
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

