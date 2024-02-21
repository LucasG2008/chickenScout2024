//
//  PastPitView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/22/24.
//

import SwiftUI

struct PitView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedPit: pitScoutData
    
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
                Section(header: Text("Pit Information")) {
                    Text("Scout Name: \(selectedPit.scoutname)")
                    Text("Team Number: \(selectedPit.teamnumber)")
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
            .navigationTitle("Pit Data")
        }
    }
}
