import SwiftUI

struct TeamView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText = ""
    @State private var selectedTeamID: String?
    
    var teamListItems = TeamListItem.loadCSV(from: "teams")
    
    var body: some View {
        
        // navigation stack to display all the robotics teams
        NavigationStack {
            List(filteredTeams) { teamItem in
                Button {
                    selectedTeamID = teamItem.teamNum
                } label: {
                    TeamRow(teamItem: teamItem)
                }
                
            }
            .navigationTitle("Teams")
            .navigationBarHidden(false)
            .searchable(text: $searchText)
            // open up detailed view when a team is clicked
            .navigationDestination(isPresented: Binding(
                            get: { selectedTeamID != nil },
                            set: { _ in selectedTeamID = nil }
                        )) {
                            teamDetailsView()
                        }
        }
        .accentColor(accentColor)
    }

    // filter teams when searching
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
    
    // get accent color
    var accentColor: Color {
            return colorScheme == .dark ? .white : .black
        }
    
    @ViewBuilder
    private func teamDetailsView() -> some View {
        if let teamID = selectedTeamID,
           let teamItem = teamListItems.first(where: { $0.teamNum == teamID }) {
            TeamDataView(forTeamID: teamItem.teamNum)
                .navigationBarTitle("Team Details", displayMode: .inline)
        }
    }
}

struct TeamRow: View {
    var teamItem: TeamListItem

    var body: some View {
        HStack {
            Text(teamItem.teamNum + ":")
            Text(teamItem.name)
        }
        .padding(8)
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView()
    }
}
