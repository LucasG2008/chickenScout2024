//
//  ScoutingView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/17/24.
//

import SwiftUI

struct InputView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: AuthViewModel
    
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
                
                Section {
                    Button  {
                        viewModel.signOut()
                    } label: {
                        Text("Force Sign Out")
                    }

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
