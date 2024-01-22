//
//  PastPitView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/22/24.
//

import SwiftUI

struct PastPitView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedPit: pitScoutData?
    
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
                    ForEach(filteredPits.sorted(by: { $0.submissionTime > $1.submissionTime }), id: \.submissionTime) { pit in
                        NavigationLink(
                            destination: PitDetailedView(pit: pit),
                            label: {
                                HStack {
                                    Text("\(pit.teamName)")
                                    Spacer()
                                    Text("\(dateFormatter.string(from: pit.submissionTime))")
                                }
                            }
                        )
                        .tag(pit)
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
            .navigationTitle("Past Pit Data")
        }
    }
    
    var filteredPits: [pitScoutData] {
        if searchText.isEmpty {
            return dataManager.pits
        } else {
            return dataManager.pits.filter { match in
                dateFormatter.string(from: match.submissionTime).localizedCaseInsensitiveContains(searchText) ||
                    match.teamName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

#Preview {
    PastPitView()
}
