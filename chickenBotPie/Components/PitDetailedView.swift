//
//  PitDetailedView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/22/24.
//

import SwiftUI

struct PitDetailedView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var dataManager = DataManager()
    
    var teamId: String
    
    @State private var pitData: pitScoutData?
    
    var body: some View {
        List {
            //Display detailed information for the match
            Section() {
                Text("Team: \(pitData?.teamnumber ?? 0000)")
                Text("Scout: \(pitData?.scoutname ?? "none")")
            } header: {
                Text("Team Info")
            }
            
            Section() {
                Text("Drive Train: \(pitData?.drivetype ?? "none")")
                Text("Best Auto: \(pitData?.bestauto ?? "none")")
                Text("Defense: \(String(pitData?.defense ?? "none"))")
            } header: {
                Text("Robot Info")
            }
            Section() {
                Text("Speaker: \(String(pitData?.speaker ?? false))")
                Text("Amp: \(String(pitData?.amp ?? false))")
                Text("Under Stage: \(String(pitData?.understage ?? false))")
                Text("Climb: \(String(pitData?.climb ?? false))")
                Text("Harmony: \(String(pitData?.harmony ?? false))")
                Text("Trap: \(String(pitData?.trap ?? false))")
            } header: {
                Text("Abilites")
            }
            Section() {
                Text("Human Player: \(String(pitData?.humanplayer ?? "none"))")
                Text("Extra Notes: \(String(pitData?.extranotes ?? "none"))")
            } header: {
                Text("Extra")
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
        .navigationTitle("Match Details")
        .onAppear {
            Task {
                do {
                    pitData = try await dataManager.fetchPitData(teamNum: teamId)
                } catch {
                    print("Error fetching pit data: \(error)")
                }
            }
        }
    }
}

#Preview {
    PitDetailedView(teamId:"7")
}
