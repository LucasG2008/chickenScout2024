//
//  TeamSearchView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/17/24.
//

import SwiftUI

struct TeamSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTeamName: String?

    @Environment(\.colorScheme) var colorScheme

    @State private var searchText = ""
    
    @State private var teamsViewModel = TBAManager()
    @State var teams: [QuickTeamView] = []

    var body: some View {
        
            NavigationStack {
                List() {
                    ForEach(filteredTeams, id: \.self) {teamItem in
                        Button {
                            selectedTeamName = teamItem.nickname
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

