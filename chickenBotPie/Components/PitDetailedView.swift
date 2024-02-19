//
//  PitDetailedView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/22/24.
//

import SwiftUI

struct PitDetailedView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let pit: pitScoutData
    
    var body: some View {
        List {
            // Display detailed information for the match
//            Text("Team: \(pit.teamName)")
//            Text("Scout: \(pit.scout)")
//            Text("Drive Train: \(pit.driveTrain)")
//            Text("Intake: \(pit.bestAuto.joined(separator: ", "))")
//               .multilineTextAlignment(.trailing)
//            Text("Defense: \(pit.defense)")
//
//            Text("Speaker: \(pit.speaker)" as String)
//            Text("Amp: \(pit.amp)" as String)
//            Text("Under Stage: \(pit.underStage)" as String)
//            Text("Climb: \(pit.climb)" as String)
//            Text("Harmony: \(pit.harmony)" as String)
//            Text("Trap: \(pit.trap)" as String)
//            Text("Human Player Skill: \(pit.humanPlayer)")
//            Text("Extra Notes: \(pit.notes)")
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
