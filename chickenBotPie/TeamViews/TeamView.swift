import SwiftUI

struct TeamView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText = ""
    @State private var selectedTeamID: String?
    @State private var selectedSortOption: SortOption = .teamNumber
    
    @State var seletedEvent = Events.all
    
    enum SortOption: String, Codable, CaseIterable {
        case teamNumber = "Team Number"
        case winRate = "Win Rate"
        case rookieYear = "Rookie Year"
    }
    
    var teamListItems = Team.loadCSV(from: "teams")
    
    var eventTeams = EventTeams.loadCSV(from: "eventTeams")
    
    var body: some View {
        
        // navigation stack to display all the robotics teams
        NavigationStack {
            
            VStack(spacing: 0) {
                
                Picker("Sort by", selection: $selectedSortOption) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
                .padding([.leading, .trailing], 15)
                .pickerStyle(SegmentedPickerStyle())
                
                //List(eventTeams) { eventData in
                //    Button {
                //        //stuff
                //    } label: {
                //        TeamEventDataRow(teamEventItem: eventData)
                //    }
                //}
                //.scrollContentBackground(.hidden)
                
                List(filteredTeams) { teamItem in
                    Button {
                        selectedTeamID = teamItem.teamNum
                    } label: {
                        TeamRow(teamItem: teamItem)
                    }
                    
                }
                .scrollContentBackground(.hidden)
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
            .background(
                Group {
                    if colorScheme == .light {
                        LinearGradient(gradient: Gradient(colors: [Color.lightBlueStart, Color.lightBlueEnd]), startPoint: .top, endPoint: .bottom)
                    } else {
                        LinearGradient(gradient: Gradient(colors: [Color.darkBlueStart, Color.darkBlueEnd]), startPoint: .top, endPoint: .bottom)
                    }
                }
                    .edgesIgnoringSafeArea(.all))
        }
        
        .accentColor(accentColor)
    }

    // filter teams when searching
    var filteredTeams: [Team] {
        var teamsToDisplay = teamListItems

        switch selectedSortOption {
        case .teamNumber:
            // No need to sort, as teams are already sorted by team number
            break
        case .winRate:
            teamsToDisplay.sort { $0.winrate > $1.winrate }
        case .rookieYear:
            teamsToDisplay.sort { $0.rookie_year < $1.rookie_year }
        }

        if searchText.isEmpty {
            return teamsToDisplay
        } else {
            return teamsToDisplay.filter { teamItem in
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
    var teamItem: Team

    var body: some View {
        HStack {
            Text(teamItem.teamNum + ":")
            Text(teamItem.name)
        }
        .padding(8)
    }
}

struct TeamEventDataRow: View {
    var teamEventItem: EventTeams
    
    var body: some View {
        HStack {
            Text(teamEventItem.teamNum + ":")
            Text(teamEventItem.name)
        }
        .padding(8)
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView()
    }
}
