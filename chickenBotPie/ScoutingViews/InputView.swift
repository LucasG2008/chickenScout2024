//
//  ScoutingView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/17/24.
//

import SwiftUI

struct InputView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedScouting: String?
    
    var body: some View {
        
        // navigation stack to navigate options
        NavigationStack {
            List {
                Button {
                    selectedScouting = "pitScouting"
                } label: {
                    Text("Pit Scouting")
                }
                
                Button {
                    selectedScouting = "standScouting"
                } label: {
                    Text("Match Scouting")
                }
                
                Section {
                    VStack{
                        Image("data-image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .cornerRadius(10)
                            .padding()
                    }
                }
                
            }
            
            
            .navigationTitle("Scouting")
            .navigationBarHidden(false)
            // open up detailed view for scouting
            .navigationDestination(isPresented: Binding(
                            get: { selectedScouting != nil },
                            set: { _ in selectedScouting = nil }
                        )) {
                            if selectedScouting == "pitScouting" {
                                PitScouting()
                                    .navigationBarTitle("Pit Scouting", displayMode: .inline)
                            } else {
                                MatchScouting()
                                    .navigationBarTitle("Match Scouting", displayMode: .inline)
                            }
                        }
            
            
        }
        .accentColor(accentColor)
    }
    
    // get accent color
    var accentColor: Color {
            return colorScheme == .dark ? .white : .black
        }
}

#Preview {
    InputView()
}