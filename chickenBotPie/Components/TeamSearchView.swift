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

    var teamListItems = TeamListItem.loadCSV(from: "teams")

    var body: some View {
            NavigationStack {
                List(filteredTeams) { teamItem in
                    Button {
                        selectedTeamName = teamItem.name
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        TeamRow(teamItem: teamItem)
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
            .accentColor(accentColor)
        }

    var filteredTeams: [TeamListItem] {
        if searchText.isEmpty {
            return teamListItems
        } else {
            return teamListItems.filter { teamItem in
                teamItem.teamNum.localizedCaseInsensitiveContains(searchText) ||
                    teamItem.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var accentColor: Color {
        return colorScheme == .dark ? .white : .black
    }
}

