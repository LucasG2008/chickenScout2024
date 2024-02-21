//
//  TeamSearchView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/17/24.
//

import SwiftUI

struct TeamListRow: View {
    var teamItem: QuickTeamView

    var body: some View {
        HStack {
            Text(String(teamItem.team_number ?? 0000) + ":")
            Text(teamItem.nickname ?? "none")
        }
        .padding(8)
    }
}

struct TeamSearchView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var selectedTeamName: String?
    @Binding var selectedTeamNumber: Int?

    @State private var searchText = ""
    
    @State private var teamsViewModel = TBAManager()
    @State var teams: [QuickTeamView] = []
    
    // Spinner
    var isLoading: Bool {
        return filteredTeams.isEmpty
    }

    var body: some View {
        
            NavigationStack {
                
                VStack(spacing: 0) {
                    
                    HStack {
                        
                    }
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(2)
                            .padding()
                            .background(.clear)
                    }
                    
                    
                    List() {
                        ForEach(filteredTeams, id: \.self) {teamItem in
                            Button {
                                selectedTeamName = teamItem.nickname
                                selectedTeamNumber = teamItem.team_number
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                TeamListRow(teamItem: teamItem)
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
                    .navigationTitle("Teams")
                    .navigationBarHidden(false)
                    .searchable(text: $searchText)
                    
                }
            }
            .task {
                Task {
                    await teamsViewModel.fetchTeamsForEvent(eventCode: "All")
                    teams = teamsViewModel.allTeams
                }
            }
        
            .accentColor(accentColor)
        }

    var filteredTeams: [QuickTeamView] {
        if searchText.isEmpty {
            return teams
        } else {
            return teams.filter { teamItem in
                String(teamItem.team_number ?? 0000).localizedCaseInsensitiveContains(searchText) ||
                String(teamItem.nickname ?? "none").localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var accentColor: Color {
        return colorScheme == .dark ? .white : .black
    }
}
