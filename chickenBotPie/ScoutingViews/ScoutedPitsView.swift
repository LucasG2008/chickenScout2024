//
//  ScoutedPitsView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 3/23/24.
//

import SwiftUI

struct ScoutedPitsView: View {
    
    @State private var dataManager = DataManager()
    @Environment(\.colorScheme) var colorScheme
    @State private var scoutedPits: [condensedPitScoutData] = []
    
    var filteredPits: [condensedPitScoutData] {
            return scoutedPits.filter { pit in
                pit.scouted==true
            }
        }
        
    
    var body: some View {
        NavigationView {
            List(filteredPits, id: \.self) { pit in
                VStack(alignment: .leading) {
                    Text("Team Number: \(pit.number)")
                        .font(.headline)
                    Text("Scouted: \(pit.scouted)")
                        .font(.subheadline)
                }
            }
        }
            .onAppear {
                Task {
                    do {
                        scoutedPits = try await dataManager.fetchScoutedPits()
                        scoutedPits = scoutedPits.reversed()
                    } catch {
                        print("Error fetching scouted pits: \(error)")
                    }
                }
            }
    }
    
}

#Preview {
    ScoutedPitsView()
}
